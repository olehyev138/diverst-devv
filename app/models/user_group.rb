class UserGroup < ActiveRecord::Base
  include ContainsFields
  include Indexable

  belongs_to :user
  belongs_to :group

  enum notifications_frequency: [:hourly, :daily, :weekly, :disabled]

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }
  scope :notifications_status, ->(frequency) {
    where(notifications_frequency: UserGroup.notifications_frequencies[frequency])
  }
  scope :active, -> { joins(:user).where(users: { active: true }) }
  scope :with_answered_survey, -> { where.not(data: nil) }

  after_commit on: [:create] { update_elasticsearch_index(user, user.enterprise, 'update') }
  after_commit on: [:destroy] { update_elasticsearch_index(user, user.enterprise, 'update') }

  def string_for_field(field)
    field.string_value info[field]
  end
end
