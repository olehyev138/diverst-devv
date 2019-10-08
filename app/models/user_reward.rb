class UserReward < BaseClass
  extend Enumerize

  enumerize :status, in: [
    :pending,
    :redeemed
  ]

  belongs_to :user
  belongs_to :reward

  validates :user, presence: true
  validates :reward, presence: true
  validates :points, numericality: { only_integer: true }, presence: true
end
