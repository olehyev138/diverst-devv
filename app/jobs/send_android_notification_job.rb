class SendAndroidNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(device_token, _message, data)
    # TODO https://github.com/spacialdb/gcm seems to be deprecated, switch to fcm (Firebase Cloud Messaging)
    # gcm = GCM.new(ENV['GCM_KEY'])
    #
    # registration_ids = [device_token]
    # options = { data: data, collapse_key: 'updated_score' }
    # gcm.send(registration_ids, options)
  end
end
