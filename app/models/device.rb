class Device < ActiveRecord::Base
  belongs_to :user
  
  @@platform = {
    web: 0,
    ios: 1,
    android: 2
  }.freeze
  
  def notify(message, data)
    if platform == 'apple'
      SendAppleNotificationJob.perform_later(token, message, data)
    elsif platform == 'android'
      SendAndroidNotificationJob.perform_later(token, message, data)
    end
  end
end
