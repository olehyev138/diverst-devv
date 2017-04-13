class UserReward < ActiveRecord::Base
  belongs_to :user
  belongs_to :reward

  validates :user, presence: true
  validates :reward, presence: true
  validates :points, numericality: { only_integer: true }, presence: true
end
