class UserGroupNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(args)
    # check if parameters exist and are valid
    raise BadRequestException.new 'Params missing' if args.blank? || args.class != Hash
    raise BadRequestException.new 'Notifications Frequency missing' if args[:notifications_frequency].nil?
    raise BadRequestException.new 'Enterprise ID missing' if args[:enterprise_id].nil?

    notifications_frequency = args[:notifications_frequency]
    enterprise_id = args[:enterprise_id]

    users_to_mail = get_users_to_mail(enterprise_id, notifications_frequency)
    return if users_to_mail.blank?

    users_to_mail.find_in_batches(batch_size: 200) do |users|
      users.each do |user|
        next unless can_send_email?(notifications_frequency, user)

        groups = []
        frequency_range = get_frequency_range(user.groups_notifications_frequency)
        user.groups.each do |group|
          events = get_events(user, group, frequency_range)
          messages = get_messages(user, group, frequency_range)
          news = get_news(user, group, frequency_range)
          social_links = get_social(user, group, frequency_range)
          participating_events = get_participating_events(user, group, frequency_range)

          groups << {
            group: group,
            events: events,
            events_count: events.count,
            messages: messages,
            messages_count: messages.count,
            news: news,
            news_count: news.count,
            social_links: social_links,
            social_links_count: social_links.count,
            participating_events: participating_events,
            participating_events_count: participating_events.count
          }
        end

        if have_updates?(groups) && notify_user?(user)
          UserGroupMailer.notification(user, groups).deliver_now
        end
      end
    end
  end

  # Gets the activerecord collection of users to email
  def get_users_to_mail(enterprise_id, notifications_frequency)
    # Make sure notification frequency is valid
    return unless User.groups_notifications_frequencies.include?(notifications_frequency.try(:to_sym))

    User.joins(:groups)
        .where(enterprise_id: enterprise_id,
               groups_notifications_frequency: User.groups_notifications_frequencies[notifications_frequency.to_sym])
        .uniq
  end

  # checks if frequency is weekly and
  def can_send_email?(frequency, user)
    return true if frequency != 'weekly'

    case user.groups_notifications_date
    when 'sunday' then Date.today.sunday?
    when 'monday' then Date.today.monday?
    when 'tuesday' then Date.today.tuesday?
    when 'wednesday' then Date.today.wednesday?
    when 'thursday' then Date.today.thursday?
    when 'friday' then Date.today.friday?
    when 'saturday' then Date.today.saturday?
    end
  end

  def notify_user?(user)
    user.last_notified_date != DateTime.now.to_date
  end

  private

  def get_frequency_range(frequency)
    case frequency
    when 'hourly' then 1.hour.ago.in_time_zone('UTC')..Time.now.in_time_zone('UTC')
    when 'weekly' then 7.days.ago.in_time_zone('UTC')..Time.now.in_time_zone('UTC')
    else Date.yesterday.beginning_of_day.in_time_zone('UTC')..Date.yesterday.end_of_day.in_time_zone('UTC')
    end
  end

  def user_segment_ids(user)
    user.segments.ids
  end

  def get_events(user, group, frequency_range)
    Initiative.where(owner_group: group, updated_at: frequency_range)
      .of_segments(user_segment_ids(user)).order(:updated_at).to_a
  end

  def get_messages(user, group, frequency_range)
    segment_ids = user_segment_ids(user)
    news_feed_link_ids = group.news_feed.all_links(segment_ids, group.enterprise).ids
    GroupMessage.joins(:news_feed_link)
      .where(news_feed_links: { id: news_feed_link_ids, approved: true }, updated_at: frequency_range)
      .of_segments(user_segment_ids(user)).order(:updated_at).to_a
  end

  def get_news(user, group, frequency_range)
    segment_ids = user_segment_ids(user)

    news_feed_link_ids = group.news_feed.all_links(segment_ids, group.enterprise).ids

    NewsLink.joins(:news_feed_link)
      .where(news_feed_links: { id: news_feed_link_ids, approved: true }, updated_at: frequency_range).order(:updated_at).to_a
  end

  def get_social(user, group, frequency_range)
    segment_ids = user_segment_ids(user)

    news_feed_link_ids = group.news_feed.all_links(segment_ids, group.enterprise).ids

    SocialLink.joins(:news_feed_link)
      .where(news_feed_links: { id: news_feed_link_ids, approved: true }, updated_at: frequency_range).order(:updated_at).to_a
  end

  def get_participating_events(user, group, frequency_range)
    Initiative.joins(:initiative_participating_groups).where(updated_at: frequency_range).where(initiative_participating_groups: { group: group })
      .of_segments(user_segment_ids(user)).order(:updated_at).to_a
  end

  def have_updates?(groups)
    groups.any? { |g|
      g[:events_count] > 0 ||
      g[:messages_count] > 0 ||
      g[:news_count] > 0 ||
      g[:social_links_count] > 0 ||
      g[:participating_events_count] > 0
    }
  end
end
