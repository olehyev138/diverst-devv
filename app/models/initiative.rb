class Initiative < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :owner, class_name: "User"
  has_many :updates, class_name: "InitiativeUpdate", dependent: :destroy
  has_many :fields, as: :container, dependent: :destroy
  has_many :expenses, dependent: :destroy, class_name: "InitiativeExpense"

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  include Elasticsearch::Model

  after_commit on: [:create] do
    __elasticsearch__.index_document(index: enterprise.es_initiatives_index_name)
  end

  after_commit on: [:update] do
    __elasticsearch__.update_document(index: enterprise.es_initiatives_index_name)
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document(index: enterprise.es_initiatives_index_name)
  end

  # Add the info from the initiative's computed fields and exclude the raw json data
  def as_indexed_json(*)
    as_json(
      except: [:data],
      methods: [:updates_info]
    )
  end

  def updates_info
    self.updates.map do |update|
      InitiativeUpdateSerializer.new(update).to_json
    end
  end

  # Custom ES mapping that creates an unanalyzed version of all string fields for exact-match term queries
  def self.es_mapping
    {
      user: {
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

  def self.reset_elasticsearch(enterprise:)
    index = enterprise.es_initiatives_index_name

    begin
      Initiative.__elasticsearch__.client.indices.delete index: index
    rescue
      nil
    end

    Initiative.__elasticsearch__.client.indices.create(
      index: index,
      body: {
        settings: Initiative.settings.to_hash,
        mappings: Initiative.es_mapping.to_hash
      }
    )

    # We don't directly call Initiative.import since activerecord-import overrides that
    Initiative.__elasticsearch__.import(
      index: index,
      query: -> {
        joins(pillar: { outcome: :group }).where(
          groups: {
            enterprise_id: enterprise.id
          }
        )
      }
    )
  end

  def highcharts_history(field:, from: 1.year.ago, to: Time.current)
    self.updates
    .where('created_at >= ?', from)
    .where('created_at <= ?', to)
    .order(created_at: :asc)
    .map do |update|
      [
        update.created_at.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
        update.info[field]
      ]
    end
  end
end
