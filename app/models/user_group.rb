class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum frequency_notification: [:real_time, :daily, :weekly, :disabled]
end
