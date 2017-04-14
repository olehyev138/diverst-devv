class UserRewardAction < ActiveRecord::Base
  enum operation: [:add, :del]

  belongs_to :user
  belongs_to :reward_action
  belongs_to :entity, polymorphic: true

  validates :user, presence: true
  validates :reward_action, presence: true
  validates :operation, presence: true
  validates :points, numericality: { only_integer: true }, presence: true
end
