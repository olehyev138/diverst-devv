require 'fcm'

class DeviceNotificationJob < ActiveJob::Base
  def perform(user_id, message_options)
    user = User.find_by_id(user_id)
    return if user.nil?
    return if user.device.nil?
    return if message_options.nil?

    fcm = FCM.new(ENV['FIREBASE_SERVER_KEY'])
    registration_ids = [user.device.token]
    fcm.send(registration_ids, message_options)
  end
end
