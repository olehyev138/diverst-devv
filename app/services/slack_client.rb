class SlackClient
  require 'slack-ruby-client'
  delegate :url_helpers, to: 'Rails.application.routes'

  def self.post_web_hook_message(encrypted_webhook, message)
    PostToSlackJob.perform_later(encrypted_webhook, RsaEncryption.encode(message.to_json))
  end

  def self.uninstall(auth)
    auth = JSON.parse RsaEncryption.decode(auth)
    HTTP.post(
      'https://slack.com/api/apps.uninstall',
      headers: {
        'Authorization' => "Bearer #{auth['access_token']}",
        'Content-Type' => 'application/json'
      }
    )
  end
end
