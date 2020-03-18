class GroupLeader < ApplicationRecord
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
    # update the permissions for this group_leader

    # budgets
    self.groups_budgets_index = policy_group_template.groups_budgets_index
    self.groups_budgets_request = policy_group_template.groups_budgets_request
    self.budget_approval = policy_group_template.budget_approval
    self.groups_budgets_manage = policy_group_template.groups_budgets_manage

    # events
    self.initiatives_index = policy_group_template.initiatives_index
    self.initiatives_manage = policy_group_template.initiatives_manage
    self.initiatives_create = policy_group_template.initiatives_create

    # manage group in entirety - this permission supersedes all other permissions
    self.groups_manage = policy_group_template.groups_manage

    # members
    self.groups_members_index = policy_group_template.groups_members_index
    self.groups_members_manage = policy_group_template.groups_members_manage

    # leaders
    self.group_leader_index = policy_group_template.group_leader_index
    self.group_leader_manage = policy_group_template.group_leader_manage

    # insights
    self.groups_insights_manage = policy_group_template.groups_insights_manage

    # layouts
    self.groups_layouts_manage = policy_group_template.groups_layouts_manage

    # setings
    self.group_settings_manage = policy_group_template.group_settings_manage

    # news
    self.news_links_index = policy_group_template.news_links_index
    self.news_links_create = policy_group_template.news_links_create
    self.news_links_manage = policy_group_template.news_links_manage

    # messages
    self.group_messages_manage = policy_group_template.group_messages_manage
    self.group_messages_index = policy_group_template.group_messages_index
    self.group_messages_create = policy_group_template.group_messages_create

    # social links
    self.social_links_manage = policy_group_template.social_links_manage
    self.social_links_index = policy_group_template.social_links_index
    self.social_links_create = policy_group_template.social_links_create

    # resources
    self.group_resources_manage = policy_group_template.group_resources_manage
    self.group_resources_index = policy_group_template.group_resources_index
    self.group_resources_create = policy_group_template.group_resources_create

    # posts
    self.group_posts_index = policy_group_template.group_posts_index
    self.manage_posts = policy_group_template.manage_posts
  end

  private

  def validate_group_membership_of_group_leader
    errors.add(:user, 'Selected user is not a member of this group') unless UserGroup.where(user_id: user_id, group_id: group_id, accepted_member: true).exists?
  end
end
