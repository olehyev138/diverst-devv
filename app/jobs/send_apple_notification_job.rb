class SendAppleNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(device_token, message, data)
    # TODO Implement this
    # apn = Houston::Client.development
    # apn.certificate = ENV['APN_CERT']
    #
    # # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
    # notification = Houston::Notification.new(device: device_token)
    # notification.alert = message
    #
    # # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
    # notification.badge = 57
    # notification.sound = 'sosumi.aiff'
    # notification.custom_data = data
    #
    # # And... sent! That's all it takes.
    # apn.push(notification)
  end
end
