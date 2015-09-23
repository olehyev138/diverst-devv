class SendAndroidNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(device_token, message, data)
    gcm = GCM.new(ENV["GCM_KEY"])

    registration_ids = [device_token]
    options = {data: data, collapse_key: "updated_score"}
    response = gcm.send(registration_ids, options)
    pp response
  end
end
