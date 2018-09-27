class UserGroup < ActiveRecord::Base
  include ContainsFields
  include Indexable

  belongs_to :user
  belongs_to :group

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }
  scope :active, -> { joins(:user).where(users: { active: true }) }

  scope :accepted_users, -> { active.joins(:group).where("groups.pending_users = 'disabled' OR (groups.pending_users = 'enabled' AND accepted_member=true)") }
  scope :with_answered_survey, -> { where.not(data: nil) }

  after_commit on: [:create] { update_elasticsearch_index(user, user.enterprise, 'update') }
  after_commit on: [:destroy] { update_elasticsearch_index(user, user.enterprise, 'update') }
  before_destroy :remove_leader_role

  def string_for_field(field)
    field.string_value info[field]
  end


  private

  def remove_leader_role
    GroupLeader.where(group_id: group_id, user_id: user_id).destroy_all
  end
end
