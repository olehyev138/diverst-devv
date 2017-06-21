class UserGroupNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(notifications_frequency)
    User.includes(user_groups: :group).find_in_batches(batch_size: 200) do |users|
      users.each do |user|
        groups = []
        user.user_groups.notifications_status(notifications_frequency).each do |user_group|
          frequency_range = get_frequency_range(user_group.notifications_frequency)
          group = user_group.group
          groups << {
            group: user_group.group,
            messages_count: get_messages_count(group, frequency_range),
            news_count: get_news_count(group, frequency_range)
          }
        end
        if have_updates?(groups)
          UserGroupMailer.notification(user, groups).deliver_now
        end
      end
    end
  end

  private

  def get_frequency_range(frequency)
    case frequency
    when "weekly" then Date.yesterday.beginning_of_week..Date.yesterday.end_of_week
    else Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
    end
  end

  def get_messages_count(group, frequency_range)
    GroupMessage.where(group: group, updated_at: frequency_range).count
  end

  def get_news_count(group, frequency_range)
    NewsLink.where(group: group, updated_at: frequency_range).count
  end

  def have_updates?(groups)
    groups.any?{ |g| g[:messages_count] > 0 || g[:news_count] > 0 }
  end
end
