class WelcomeNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(group_id, user_id)
    return if group_id.nil? || user_id.nil?

    WelcomeMailer.notification(group_id, user_id).deliver_now
  end
end
