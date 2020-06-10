class PollResponse < ApplicationRecord
  FIELD_DEFINER_NAME = :poll
  FIELD_ASSOCIATION_NAME = :fields
  belongs_to :poll, counter_cache: :responses_count

  include PollResponse::Actions
  include ContainsFieldData

  belongs_to :user
  has_many :user_reward_actions, dependent: :destroy

  validates_length_of :data, maximum: 65535

  def group
    poll&.initiative&.group
  end
end
