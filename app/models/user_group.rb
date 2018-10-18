class UserGroup < ActiveRecord::Base
  include ContainsFields
  include Indexable

  # associations
  belongs_to :user
  belongs_to :group
  
  # validations
  validates_uniqueness_of :user, scope: [:group], :message => "is already a member of this group"

  enum notifications_frequency: [:hourly, :daily, :weekly, :disabled]
  enum notifications_date: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  scope :top_participants, ->(n) { order(total_weekly_points: :desc).limit(n) }
  scope :notifications_status, ->(frequency) {
    where(notifications_frequency: UserGroup.notifications_frequencies[frequency])
  }
  scope :active, -> { joins(:user).where(users: { active: true }) }

  scope :accepted_users, -> { active.joins(:group).where("groups.pending_users = 'disabled' OR (groups.pending_users = 'enabled' AND accepted_member=true)") }
  scope :with_answered_survey, -> { where.not(data: nil) }

  after_commit on: [:create] { update_elasticsearch_index(user, user.enterprise, 'update') }
  after_commit on: [:destroy] { update_elasticsearch_index(user, user.enterprise, 'update') }
  before_destroy :remove_leader_role
  
  after_create { update_mentor_fields(true) }
  after_destroy { update_mentor_fields(false) }
  
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
