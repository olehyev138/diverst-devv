class PostToSlackJob < ActiveJob::Base
  queue_as :default

  def perform(encrypted_webhook, encrypted_message)
    HTTP.post(RsaEncryption.decode(encrypted_webhook), body: RsaEncryption.decode(encrypted_message))
  end
end
