class UserGroup < ApplicationRecord
  @@fields_holder_name = 'group'
  @@field_association_name = 'survey_fields'

  include ContainsFieldData
  include UserGroup::Actions

  # associations
  belongs_to :user
  belongs_to :group
  has_many :field_data, class_name: 'FieldData', as: :fieldable, dependent: :destroy

  # validations
  validates_length_of :data, maximum: 65535
  validates_uniqueness_of :user, scope: [:group], message: 'is already a member of this group'

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }

  scope :active, -> { joins(:user).where(users: { active: true }) }
  scope :inactive, -> { joins(:user).where(users: { active: false }) }

  scope :pending, -> { active.joins(:group).where(accepted_member: false, groups: { pending_users: 'enabled' }) }
  scope :accepted_users, -> { active.joins(:group).where("groups.pending_users = 'disabled' OR (groups.pending_users = 'enabled' AND accepted_member=true)") }

  scope :with_answered_survey, -> { where.not(data: nil) }

  scope :for_segment_ids, -> (segment_ids) { joins(user: [:segments]).where('segments.id' => segment_ids).distinct if segment_ids.any? }

  scope :joined_from, -> (from) { where('user_groups.created_at >= ?', from) }
  scope :joined_to, -> (to) { where('user_groups.created_at <= ?', to) }

  before_destroy :remove_leader_role

  after_create { update_mentor_fields(true) }
  after_destroy { update_mentor_fields(false) }

  settings do
    # dynamic template for field_data hash - maps value/data string to es type 'keyword'
    #  - they must be keywords in order to perform aggregations on them
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
      indexes :user_id, type: :integer
      indexes :group_id, type: :integer
      indexes :created_at, type: :date
      indexes :group do
        indexes :enterprise_id, type: :integer
        indexes :parent_id, type: :integer
        indexes :name, type: :keyword
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
      indexes :user do
        indexes :enterprise_id, type: :integer
        indexes :created_at, type: :date
        indexes :active, type: :boolean
        indexes :mentor, type: :boolean
        indexes :mentee, type: :boolean
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:user_id, :group_id, :created_at],
        include: {
          group: {
            only: [:enterprise_id, :parent_id, :name],
            include: { parent: { only: [:name] } },
          },
          user: {
            only: [:enterprise_id, :created_at, :mentor, :mentee, :active],
          }
        },
        methods: [:field_data]
      )
    )
    .deep_merge({
      'created_at' => self.created_at.beginning_of_hour,
      'user' => {
        'created_at' => self.user.created_at.beginning_of_hour,
      }
    })
  end

  def self.fields_holder_name
    @@fields_holder_name
  end

  def self.field_association_name
    @@field_association_name
  end

  # For use by ES indexing - method has to be defined in same class
  def user_field_data
    user.indexed_field_data
  end

  def string_for_field(field)
    field.string_value info[field]
  end

  def update_mentor_fields(boolean)
    if group.default_mentor_group
      user.mentee = boolean
      user.mentor = boolean
      user.save!
    end
  end

  private

  def remove_leader_role
    GroupLeader.where(group_id: group_id, user_id: user_id).destroy_all
  end
end
