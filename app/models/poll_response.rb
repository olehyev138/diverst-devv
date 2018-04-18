class PollResponse < ActiveRecord::Base
  include ContainsFields
  include Indexable

  belongs_to :poll
  belongs_to :user
  
  has_many :user_reward_actions

  after_commit on: [:create] { update_elasticsearch_index(user, poll.enterprise, 'index') }
  after_commit on: [:update] { update_elasticsearch_index(user, poll.enterprise, 'update') }
  after_commit on: [:destroy] { update_elasticsearch_index(user, poll.enterprise, 'delete') }

  def group
    poll.try(:initiative).try(:group)
  end
end
