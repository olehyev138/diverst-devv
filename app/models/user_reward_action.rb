class UserRewardAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward_action

  validates :user, presence: true
  validates :reward_action, presence: true
end
