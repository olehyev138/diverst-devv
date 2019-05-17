class PollResponse < ApplicationRecord
  include ContainsFields

  belongs_to :poll
  belongs_to :user

  has_many :user_reward_actions, dependent: :destroy

  def group
    poll.try(:initiative).try(:group)
  end
end
