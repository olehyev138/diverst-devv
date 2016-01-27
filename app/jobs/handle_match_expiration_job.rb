class HandleMatchExpirationJob < ActiveJob::Base
  queue_as :default

  def perform
    # Send push notifications for conversations that expire soon
    Match.soon_expired.each(&:expires_soon_notification)

    # Archive expired conversations
    Match.expired.not_archived.update_all(archived: true)
  end
end
