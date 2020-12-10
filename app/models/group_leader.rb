class GroupLeader < ApplicationRecord
  include GroupLeader::Actions

  belongs_to :leader_of, polymorphic: true
  belongs_to :user
  belongs_to :user_role
  has_one :policy_group_template, through: :user_role

  polymorphic_alias :leader_of, Group
  polymorphic_alias :leader_of, Region

  validates_length_of :position_name, maximum: 191
  validates_presence_of :position_name
  validates_presence_of :leader_of
  validates_presence_of :user
  validates_presence_of :user_role
  validates :user_id, uniqueness: { message: -> (record, o) { I18n.t('errors.group.leader_uniqueness_1') + "#{record.leader_of_type.downcase}" + I18n.t('errors.group.leader_uniqueness_2') },
                                    scope: [:leader_of_id, :leader_of_type] }

  scope :visible,   -> { where(visible: true) }
  scope :role_ids,  -> { distinct.pluck(:user_role_id) }

  before_save :set_admin_permissions
  validate :validate_group_membership_of_group_leader, if: -> { leader_of_type == 'Group' }
  validate :validate_group_membership_of_parent_of_region, if: -> { leader_of_type == 'Region' }

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
    errors.add(:user, I18n.t('errors.group.user_not_member')) unless UserGroup.find_by(user_id: user_id, group_id: group_id)&.is_accepted?
  end

  def validate_group_membership_of_parent_of_region
    errors.add(:user, I18n.t('errors.group.user_not_member_region')) unless UserGroup.find_by(user_id: user_id, group_id: region&.parent_id)&.is_accepted?
  end
end
