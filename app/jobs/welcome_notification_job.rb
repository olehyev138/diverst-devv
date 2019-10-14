class WelcomeNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(group_id, user_id)
    group, user = Group.find_by(id: group_id), User.find_by(id: user_id)

    return if group.nil? || user.nil?

    WelcomeMailer.notification(group_id, user_id).deliver_now
  end
end
