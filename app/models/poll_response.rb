class PollResponse < ApplicationRecord
  include ContainsFields

  belongs_to :poll
  belongs_to :user

  has_many :user_reward_actions, dependent: :destroy

  validates_length_of :data, maximum: 65535
  def group
    poll.try(:initiative).try(:group)
  end
end
