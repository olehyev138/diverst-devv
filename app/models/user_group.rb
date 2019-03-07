class UserGroup < BaseClass
  include ContainsFields

  # associations
  belongs_to :user
  belongs_to :group

  # validations
  validates_uniqueness_of :user, scope: [:group], :message => "is already a member of this group"

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }
  scope :active, -> { joins(:user).where(users: { active: true }) }

  scope :accepted_users, -> { active.joins(:group).where("groups.pending_users = 'disabled' OR (groups.pending_users = 'enabled' AND accepted_member=true)") }
  scope :with_answered_survey, -> { where.not(data: nil) }

  before_destroy :remove_leader_role

  after_create { update_mentor_fields(true) }
  after_destroy { update_mentor_fields(false) }

  settings do
    mappings dynamic: false do
      indexes :user_id, type: :integer
      indexes :group_id, type: :integer
      indexes :created_at, type: :date
      indexes :group  do
        indexes :enterprise_id, type: :integer
        indexes :parent_id, type: :integer
        indexes :name, type: :keyword
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
      indexes :user do
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
        include: { group: {
          only: [:enterprise_id, :parent_id, :name],
          include: { parent: { only: [:name] } },
        }, user: { only: [:mentor, :mentee, :active] }}
      )
    )
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
