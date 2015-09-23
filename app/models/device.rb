class Device < ActiveRecord::Base
  @@platform = {
    web: 0,
    ios: 1,
    android: 2
  }.freeze

  def self.platform
    @@status
  end

  def notify(message, data)
    if self.platform == 'apple'
      SendAppleNotificationJob.perform_later(self.token, message, data)
    elsif self.platform == 'android'
      SendAndroidNotificationJob.perform_later(self.token, message, data)
    end
  end
end
