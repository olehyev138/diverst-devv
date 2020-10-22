class GroupLeader < ApplicationRecord
  include GroupLeader::Actions

  belongs_to :group
  belongs_to :user
  belongs_to :user_role
  has_one :policy_group_template, through: :user_role

  validates_length_of :position_name, maximum: 191
  validates_presence_of :position_name
  validates_presence_of :group
  validates_presence_of :user
  validates_presence_of :user_role
  validates :user_id, uniqueness: { message: 'already exists as a group leader', scope: :group_id }

  scope :visible,   -> { where(visible: true) }
  scope :role_ids,  -> { distinct.pluck(:user_role_id) }

  before_save :set_admin_permissions
  validate :validate_group_membership_of_group_leader


  # we want to make sure the group_leader can access certain
  # resources in the admin view

  def set_admin_permissions
    attributes = if policy_group_template.present?
                   policy_group_template.create_new_group_leader
                 else
                   PolicyGroupTemplate::EMPTY_GROUP_LEADER_ATTRIBUTES.dup
                 end

    attributes.delete(:manage_all)
    assign_attributes(attributes)
  end

  private

  def validate_group_membership_of_group_leader
    errors.add(:user, 'Selected user is not a member of this group') unless UserGroup.find_by(user_id: user_id, group_id: group_id)&.is_accepted?
  end
end
