class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }
end
