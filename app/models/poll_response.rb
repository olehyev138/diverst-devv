class PollResponse < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include ContainsFields

  belongs_to :poll
  belongs_to :employee

  def self.mappingue
    {
      poll_responses: {
        dynamic_templates: [{
          string_template: {
            type: "string",
            mapping: {
              fields: {
                raw: {
                  type: "string",
                  index: "not_analyzed"
                }
              }
            },
            match_mapping_type: "string",
            match: "*"
          }
        }],
        properties: {}
      }
    }
  end

  def as_indexed_json(*)
    self.as_json({
      except: [:data],
      methods: [:info]
    })
  end
end
