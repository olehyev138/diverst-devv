class HandleMatchExpirationJob < ActiveJob::Base
  queue_as :default

  def perform
    # Send push notifications for conversations that expire soon
    Match.soon_expired.each do |match|
      match.expires_soon_notification
    end

    # Archive expired conversations
    Match.expired.not_archived.update_all(archived: true)
  end
end