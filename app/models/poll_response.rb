class PollResponse < ActiveRecord::Base
  include ContainsFields

  belongs_to :poll
  belongs_to :user

  after_commit on: [:create] do
    IndexElasticsearchJob.perform_later(
      model_name: 'User',
      operation: 'index',
      index: User.es_index_name(enterprise: poll.enterprise),
      record_id: user.id
    )
  end
end
