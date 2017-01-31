class UserGroupNotificationJob < ActiveJob::Base
  queue_as :default

  def perform
    @messages, @news = {}, {}
    User.find_in_batches(batch_size: 200) do |users|
      users.each do |user|
        groups = []
        user.user_groups(enable_notification: true).each do |user_group|
          group = user_group.group
          groups << {
            group: user_group.group,
            messages_count: @messages[group.id] || get_messages_count(group),
            news_count: @news[group.id] || get_news_count(group)
          }
        end
        if there_is_updates?(groups)
          UserGroupMailer.notification(user, groups).deliver_now
        end
      end
    end
  end

  private
  def get_messages_count(group)
    @messages[group.id] = GroupMessage.where(group: group, updated_at: today).count
  end

  def get_news_count(group)
    @news[group.id] = NewsLink.where(group: group, updated_at: today).count
  end

  def today
    Date.today.beginning_of_day..Date.today.end_of_day
  end

  def there_is_updates?(groups)
    groups.any?{ |g| g[:messages_count] > 0 || g[:news_count] > 0 }
  end
end
