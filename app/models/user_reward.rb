class UserReward < ApplicationRecord
  extend Enumerize

  enumerize :status, in: {
    pending: 0,
    redeemed: 1,
    forfeited: 2
  }

  belongs_to :user
  belongs_to :reward

  validates :user, presence: true
  validates :reward, presence: true
  validates :points, numericality: { only_integer: true }, presence: true


  def approve_reward_redemption
    self.update(status: 1)
    self.user.update(credits: Rewards::Points::Reporting.new(self.user).user_credits)
  end
end
