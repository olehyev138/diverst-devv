class Sample < ActiveRecord::Base
  belongs_to :user

  include ContainsFields
  include Elasticsearch::Model

  after_commit on: [:create] do
    IndexElasticsearchJob.perform_later(
      model_name: 'Sample',
      operation: 'index',
      index: user.enterprise.es_samples_index_name,
      record_id: id
    )
  end

  after_commit on: [:update] do
    IndexElasticsearchJob.perform_later(
      model_name: 'Sample',
      operation: 'update',
      index: user.enterprise.es_samples_index_name,
      record_id: id
    )
  end

  after_commit on: [:destroy] do
    IndexElasticsearchJob.perform_later(
      model_name: 'Sample',
      operation: 'delete',
      index: user.enterprise.es_samples_index_name,
      record_id: id
    )
  end

  scope :es_index_for_enterprise, -> (enterprise) { joins(:user).where(users: { enterprise_id: enterprise.id }) }

  # Add the combined info from both the user's fields and his/her poll answers to ES
  def as_indexed_json(*)
    as_json(except: [:data],
            methods: [:info])
  end

  # Custom ES mapping that creates an unanalyzed version of all string fields for exact-match term queries
  def self.custom_mapping
    {
      sample: {
        dynamic_templates: [{
          string_template: {
            type: 'string',
            mapping: {
              fields: {
                raw: {
                  type: 'string',
                  index: 'not_analyzed'
                }
              }
            },
            match_mapping_type: 'string',
            match: '*'
          }
        }],
        properties: {}
      }
    }
  end
end
