class UserGroupInstantNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(group, messages_count: 0, news_count: 0)
    User
      .joins(user_groups: :group)
      .where(groups: { id: group.id })
      .where(user_groups: { frequency_notification: UserGroup.frequency_notifications[:real_time] })
      .find_in_batches(batch_size: 200).each do |users|
        users.each do |user|
          groups = [{ group: group, messages_count: messages_count, news_count: news_count }]
          UserGroupMailer.notification(user, groups).deliver_now
        end
      end
  end
end
