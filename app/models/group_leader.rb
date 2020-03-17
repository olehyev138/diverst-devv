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

  before_save  :set_admin_permissions
  validate :validate_group_membership_of_group_leader


  # we want to make sure the group_leader can access certain
  # resources in the admin view

  def set_admin_permissions
    # get the template that corresponds to the group_leader role
    template = PolicyGroupTemplate.joins(:user_role).find_by(user_roles: { id: user_role_id })

    # update the permissions for this group_leader

    # budgets
    self.groups_budgets_index = template.groups_budgets_index
    self.groups_budgets_request = template.groups_budgets_request
    self.budget_approval = template.budget_approval
    self.groups_budgets_manage = template.groups_budgets_manage

    # events
    self.initiatives_index = template.initiatives_index
    self.initiatives_manage = template.initiatives_manage
    self.initiatives_create = template.initiatives_create

    # manage group in entirety - this permission supersedes all other permissions
    self.groups_manage = template.groups_manage

    # members
    self.groups_members_index = template.groups_members_index
    self.groups_members_manage = template.groups_members_manage

    # leaders
    self.group_leader_index = template.group_leader_index
    self.group_leader_manage = template.group_leader_manage

    # insights
    self.groups_insights_manage = template.groups_insights_manage

    # layouts
    self.groups_layouts_manage = template.groups_layouts_manage

    # setings
    self.group_settings_manage = template.group_settings_manage

    # news
    self.news_links_index = template.news_links_index
    self.news_links_create = template.news_links_create
    self.news_links_manage = template.news_links_manage

    # messages
    self.group_messages_manage = template.group_messages_manage
    self.group_messages_index = template.group_messages_index
    self.group_messages_create = template.group_messages_create

    # social links
    self.social_links_manage = template.social_links_manage
    self.social_links_index = template.social_links_index
    self.social_links_create = template.social_links_create

    # resources
    self.group_resources_manage = template.group_resources_manage
    self.group_resources_index = template.group_resources_index
    self.group_resources_create = template.group_resources_create

    # posts
    self.group_posts_index = template.group_posts_index
    self.manage_posts = template.manage_posts
  end

  private

  def validate_group_membership_of_group_leader
    errors.add(:user, 'Selected user is not a member of this group') unless UserGroup.where(user_id: user_id, group_id: group_id, accepted_member: true).exists?
  end
end
