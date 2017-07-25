class UserGroup < ActiveRecord::Base
  include ContainsFields

  belongs_to :user
  belongs_to :group

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }

  enum notifications_frequency: [:real_time, :daily, :weekly, :disabled]

  scope :notifications_status, ->(frequency) {
    where(notifications_frequency: UserGroup.notifications_frequencies[frequency])
  }

  scope :with_answered_survey, -> { where.not(data: nil) }

  def string_for_field(field)
    field.string_value info[field]
  end
end
