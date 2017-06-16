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

  after_commit on: [:update] do
    IndexElasticsearchJob.perform_later(
      model_name: 'User',
      operation: 'update',
      index: User.es_index_name(enterprise: poll.enterprise),
      record_id: user.id
    )
  end

  after_commit on: [:destroy] do
    IndexElasticsearchJob.perform_later(
      model_name: 'User',
      operation: 'delete',
      index: User.es_index_name(enterprise: poll.enterprise),
      record_id: user.id
    )
  end

  def group
    poll.try(:initiative).try(:group)
  end
end
