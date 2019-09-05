class UsersSegment < ApplicationRecord
  include UsersSegment::Actions

  belongs_to :user
  belongs_to :segment

  # validations
  validates_uniqueness_of :user, scope: [:segment], message: 'is already a member of this segment'

  settings do
    # dynamic template for combined_info fields, maps them to keyword
    mappings dynamic_templates: [
      {
        string_template: {
          match_mapping_type: 'string',
          match: '*',
          mapping: {
            type: 'keyword',
          }
        }
      }
    ] do
      indexes :segment do
        indexes :enterprise_id, type: :integer
        indexes :name, type: :keyword
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
      indexes :user do
        indexes :enterprise_id, type: :integer
        indexes :created_at, type: :date
        indexes :field_data do
          indexes :user_id, type: :integer
          indexes :field_id, type: :integer
          indexes :data, type: :keyword
        end
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        include: {
          segment: {
            only: [:enterprise_id, :name],
            include: { parent: { only: [:name] } }
          },
          user: {
            only: [:created_at, :enterprise_id],
            include: { field_data: { only: [:user_id, :field_id, :data] } }
          }
        },
        methods: [:user_combined_info]
      )
    )
    .deep_merge({ 'user' => { 'created_at' => user.created_at.beginning_of_hour } })
  end

  def user_combined_info
    user.combined_info
  end
end
