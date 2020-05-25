class GroupPolicy < ApplicationPolicy
  attr_reader :user_group, :group_leader

  def initialize(user, record, params = nil)
    super(user, record, params)
    if Group === record
      @user_group = record.user_groups.find { |ug| ug.user_id == user.id }
      @group_leader = record.group_leaders.find { |gl| gl.user_id == user.id }
    end
  end

  def index?
    return true if create?
    return true if has_group_leader_permissions?('groups_index')

    @policy_group.groups_index?
  end

  alias_method :colors?, :index?

  def current_annual_budgets?
    index?
  end

  def current_annual_budget?
    update?
  end

  def carryover_annual_budget?
    update?
  end

  def reset_annual_budget?
    update?
  end

  def annual_budgets?
    update?
  end

  def new?
    create?
  end

  def show?
    index? || is_an_accepted_member?
  end

  def initiatives?
    show?
  end

  def create?
    return true if manage_all?
    return true if @policy_group.groups_manage?
    return true if has_group_leader_permissions?('groups_manage')
    return true if has_group_leader_permissions?('groups_create')

    @policy_group.groups_create?
  end

  def fields?
    update?
  end

  def create_field?
    update?
  end

  def updates?
    update?
  end

  def update_prototype?
    updates?
  end

  def create_update?
    update?
  end

  def update_all_sub_groups?
    create?
  end

  def sort?
    index?
  end

  # VIEW PERMISSIONS

  def events_view?
    InitiativePolicy.new(self, Initiative).index?
  end

  def members_view?
    UserGroupPolicy.new(self, UserGroup).index?
  end

  def news_view?
    NewsFeedLinkPolicy.new(self, NewsFeedLink).index?
  end

  def budgets_view?
    BudgetPolicy.new(self, AnnualBudget).index?
  end

  def resources_view?
    GroupResourcePolicy.new(self, Resource).index?
  end

  def annual_budgets_view?
    AnnualBudgetPolicy.new(self, AnnualBudget).index?
  end

  def leaders_view?
    GroupLeaderPolicy.new(self, GroupLeader).index?
  end

  # CREATE PERMISSIONS

  def events_create?
    InitiativePolicy.new(self, Initiative).create?
  end

  def members_create?
    UserGroupPolicy.new(self, UserGroup).create?
  end

  def message_create?
    GroupMessagePolicy.new(self, GroupMessage).create?
  end

  def news_link_create?
    NewsLinkPolicy.new(self, NewsLink).create?
  end

  def social_link_create?
    user.enterprise.enable_social_media && SocialLinkPolicy.new(self, SocialLink).create?
  end

  def news_create?
    message_create? || news_link_create? || social_link_create?
  end

  def resources_create?
    GroupResourcePolicy.new(self, Resource).create?
  end

  def budgets_create?
    BudgetPolicy.new(self, AnnualBudget).create?
  end

  def leaders_create?
    GroupLeaderPolicy.new(self, GroupLeader).create?
  end

  # MANAGE PERMISSIONS

  def members_destroy?
    UserGroupPolicy.new(self, UserGroup).destroy?
  end

  def leaders_manage?
    GroupLeaderPolicy.new(self, GroupLeader).manage?
  end

  def kpi_manage?
    GroupUpdatePolicy.new(self, Update).manage?
  end

  def events_manage?
    InitiativePolicy.new(self, Initiative).manage?
  end

  def news_manage?
    NewsFeedLinkPolicy.new(self, NewsFeedLink).manage?
  end

  def annual_budgets_manage?
    AnnualBudgetPolicy.new(self, AnnualBudget).manage?
  end

  def resources_manage?
    GroupResourcePolicy.new(self, Resource).manage?
  end

  # ========================================
  # MAYBE DEPRECATED
  # ========================================

  # move these to separate policies
  def view_all?
    create?
  end

  def add_category?
    create?
  end

  def update_with_new_category?
    create?
  end

  def assign_leaders?
    return true if manage_all?
    return true if has_group_leader_permissions?('group_leader_manage')

    @policy_group.group_leader_manage?
  end

  def manage_all_groups?
    # return true if parent_group_permissions?
    # super admin
    return true if manage_all?
    return true if has_group_leader_permissions?('groups_manage') && has_group_leader_permissions?('group_settings_manage')

    # groups manager
    @policy_group.groups_manage? && @policy_group.group_settings_manage?
  end

  def manage_all_group_budgets?
    # return true if parent_group_permissions?
    # super admin
    return true if manage_all?
    return true if has_group_leader_permissions?('groups_manage') && has_group_leader_permissions?('groups_budgets_manage')

    # groups manager
    @policy_group.groups_manage? && @policy_group.groups_budgets_manage?
  end

  def manage?
    return true if manage_all?
    return true if has_group_leader_permissions?('groups_manage')

    @policy_group.groups_manage?
  end

  def is_a_pending_member?
    is_a_member? && @user_group.accepted_member == false
  end

  def is_an_accepted_member?
    is_a_member? && @user_group.accepted_member == true
  end

  def is_a_member?
    @user_group.present?
  end

  def is_a_leader?
    @group_leader.present?
  end

  def update?
    return true if manage?
    return true if has_group_leader_permissions?('group_settings_manage')

    @record.owner == @user
  end

  def parent_group_permissions?
    return false if @record.parent.nil?

    ::GroupPolicy.new(@user, @record.parent).manage?
  end

  def destroy?
    update?
  end

  def calendar?
    return true if manage_all?
    return true if has_group_leader_permissions?('global_calendar')

    @policy_group.global_calendar?
  end

  def insights?
    return true if parent_group_permissions?
    # super admin
    return true if @policy_group.manage_all?
    # groups manager
    return true if @policy_group.groups_manage? && @policy_group.groups_insights_manage?
    # group leader
    return true if has_group_leader_permissions?('groups_insights_manage')

    # group member
    is_a_member? && @policy_group.groups_insights_manage?
  end

  def layouts?
    return true if parent_group_permissions?
    # super admin
    return true if @policy_group.manage_all?
    # groups manager
    return true if @policy_group.groups_manage? && @policy_group.groups_layouts_manage?
    # group leader
    return true if has_group_leader_permissions?('groups_layouts_manage')

    # group member
    is_a_member? && @policy_group.groups_layouts_manage?
  end

  def settings?
    return true if parent_group_permissions?
    # super admin
    return true if @policy_group.manage_all?
    # groups manager
    return true if @policy_group.groups_manage? && @policy_group.group_settings_manage?
    # group leader
    return true if has_group_leader_permissions?('group_settings_manage')

    # group member
    is_a_member? && @policy_group.group_settings_manage?
  end

  def has_group_leader_permissions?(permission)
    return false unless is_a_leader?

    group_leader[permission] || false
  end

  class Scope < Scope
    delegate :manage?, to: :policy
    delegate :index?, to: :policy

    def resolve
      if manage?
        scope.where(enterprise_id: user.enterprise_id).all
      elsif index?
        scope.joins(:user_groups)
            .where(enterprise_id: user.enterprise_id)
            .where('user_groups.user_id = ? OR groups.private = FALSE', user.id).all
      else
        scope.none
      end
    end
  end
end
