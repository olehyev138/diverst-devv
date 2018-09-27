class UserGroupNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(args)
    # check if parameters exist and are valid
    raise BadRequestException.new "Params missing" if args.nil? || args.empty? || args.class != Hash
    raise BadRequestException.new "Notifications Frequency missing" if args[:notifications_frequency].nil?
    raise BadRequestException.new "Enterprise ID missing" if args[:enterprise_id].nil?
    
    notifications_frequency = args[:notifications_frequency]
    enterprise_id = args[:enterprise_id]
    
    User.where(:enterprise_id => enterprise_id).notifications_status(notifications_frequency).includes(user_groups: :group).find_in_batches(batch_size: 200) do |users|
      users.each do |user|
        groups = []
        # user.user_groups.accepted_users.active.each do |user_group|
        #   # check if notifications_frequency is weekly and check current date is equal to
        #   # selected user_group
        #   next unless can_send_email?(notifications_frequency, user_group)
        #   group = user_group.group
        #   frequency_range = get_frequency_range(user_group.notifications_frequency)
        #   groups << {
        #     group: user_group.group,
        #     events_count: get_events_count(user, group, frequency_range),
        #     messages_count: get_messages_count(user, group, frequency_range),
        #     news_count: get_news_count(user, group, frequency_range),
        #     social_links_count: get_social_count(user, group, frequency_range),
        #     participating_events_count: get_participating_events_count(user, group, frequency_range)
        #   }
        # end

        next unless can_send_email?(notifications_frequency, user)
        frequency_range = get_frequency_range(user.groups_notifications_frequency)
        user.groups.each do |group|
          groups << {
            group: group,
            events_count: get_events_count(user, group, frequency_range),
            messages_count: get_messages_count(user, group, frequency_range),
            news_count: get_news_count(user, group, frequency_range),
            social_links_count: get_social_count(user, group, frequency_range),
            participating_events_count: get_participating_events_count(user, group, frequency_range)
          }
        end

        if have_updates?(groups)
          UserGroupMailer.notification(user, groups).deliver_now
        end
      end
    end
  end

  # checks if frequency is weekly and 
  def can_send_email?(frequency, user)
    return true if frequency != "weekly"
    case user.groups_notifications_date
    when "sunday" then Date.today.sunday?
    when "monday" then Date.today.monday?
    when "tuesday" then Date.today.tuesday?
    when "wednesday" then Date.today.wednesday?
    when "thursday" then Date.today.thursday?
    when "friday" then Date.today.friday?
    when "saturday" then Date.today.saturday?
    end
  end

  private

  def get_frequency_range(frequency)
    case frequency
    when "hourly" then 1.hour.ago.in_time_zone("UTC")..Time.now.in_time_zone("UTC")
    when "weekly" then Date.yesterday.beginning_of_week.in_time_zone("UTC")..Date.yesterday.end_of_week.in_time_zone("UTC")
    else Date.yesterday.beginning_of_day.in_time_zone("UTC")..Date.yesterday.end_of_day.in_time_zone("UTC")
    end
  end

  def user_segment_ids(user)
    user.segments.ids
  end

  def get_events_count(user, group, frequency_range)
    Initiative.where(owner_group: group, updated_at: frequency_range)
      .of_segments(user_segment_ids(user))
      .count
  end

  def get_messages_count(user, group, frequency_range)
    segment_ids = user_segment_ids(user)
    news_feed_link_ids = NewsFeed.all_links(group.news_feed.id, segment_ids).ids
    return GroupMessage.joins(:news_feed_link)
          .where(:news_feed_links => {:id => news_feed_link_ids}, :updated_at => frequency_range)
          .of_segments(user_segment_ids(user))
          .count
  end

  def get_news_count(user, group, frequency_range)
    segment_ids = user_segment_ids(user)
    
    news_feed_link_ids = NewsFeed.all_links(group.news_feed.id, segment_ids).ids
    
    return NewsLink.joins(:news_feed_link)
          .where(:news_feed_links => {:id => news_feed_link_ids}, :updated_at => frequency_range)
          .count
  end
  
  def get_social_count(user, group, frequency_range)
    segment_ids = user_segment_ids(user)
    
    news_feed_link_ids = NewsFeed.all_links(group.news_feed.id, segment_ids).ids
    
    return SocialLink.joins(:news_feed_link)
          .where(:news_feed_links => {:id => news_feed_link_ids}, :updated_at => frequency_range)
          .count
  end
  
  def get_participating_events_count(user, group, frequency_range)
    Initiative.joins(:initiative_participating_groups).where(updated_at: frequency_range).where(initiative_participating_groups: {group: group})
    .of_segments(user_segment_ids(user))
    .count
  end

  def have_updates?(groups)
    groups.any?{ |g| 
      g[:events_count] > 0 ||
      g[:messages_count] > 0 || 
      g[:news_count] > 0 || 
      g[:social_links_count] > 0 ||
      g[:participating_events_count] > 0
    }
  end
end
