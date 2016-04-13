class Sample < ActiveRecord::Base
  belongs_to :user

  include ContainsFields
  include Elasticsearch::Model

  after_commit on: [:create] do
    __elasticsearch__.index_document(index: user.enterprise.es_samples_index_name)
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document(index: user.enterprise.es_samples_index_name)
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document(index: user.enterprise.es_samples_index_name)
  end

  # Deletes the ES index, creates a new one and imports all users in it
  def self.reset_elasticsearch(enterprise:)
    index = enterprise.es_samples_index_name

    begin
      Sample.__elasticsearch__.client.indices.delete index: index
    rescue
      nil
    end

    Sample.__elasticsearch__.client.indices.create(
      index: index,
      body: {
        settings: Sample.settings.to_hash,
        mappings: Sample.custom_mapping.to_hash
      }
    )

    # We don't directly call Sample.import since activerecord-import overrides that
    Sample.__elasticsearch__.import(
      index: index,
      query: -> {
        joins(:user).where(users: { enterprise_id: enterprise.id })
      }
    )
  end

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
