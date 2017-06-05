class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum notifications_frequency: [:real_time, :daily, :weekly, :disabled]

  scope :notifications_status, ->(frequency) {
    where(notifications_frequency: UserGroup.notifications_frequencies[frequency])
  }
end
