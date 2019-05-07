class GroupPolicy < ApplicationPolicy
  def index?
    return true if create?
      return true if basic_group_leader_permission?('groups_index')
      @policy_group.groups_index?
  end

  def new?
    create?
  end

  def show?
    index?
  end

  def create?
    return true if manage_all?
      return true if @policy_group.groups_manage?
      return true if basic_group_leader_permission?('groups_manage')
      return true if basic_group_leader_permission?('groups_create')
      @policy_group.groups_create?
  end

  def update_all_sub_groups?
    create?
  end

  def sort?
    index?
  end

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

  def update?
    return true if @policy_group.groups_manage?
      return true if @record.owner == @user

      @record.managers.include?(user)
  end

  def manage_all_groups?
    # return true if parent_group_permissions?
    # super admin
    return true if manage_all?
      return true if basic_group_leader_permission?('groups_manage') && basic_group_leader_permission?('group_settings_manage')

      # groups manager
      return true if @policy_group.groups_manage? && @policy_group.group_settings_manage?
  end

  def manage_all_group_budgets?
    # return true if parent_group_permissions?
    # super admin
    return true if manage_all?
      return true if basic_group_leader_permission?('groups_manage') && basic_group_leader_permission?('groups_budgets_manage')

      # groups manager
      return true if @policy_group.groups_manage? && @policy_group.groups_budgets_manage?
  end

  def manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('groups_manage')
    @policy_group.groups_manage?
  end

  def is_a_pending_member?
    UserGroup.where(accepted_member: false, user_id: user.id, group_id: @record.id).exists?
  end

  def is_an_accepted_member?
    UserGroup.where(accepted_member: true, user_id: user.id, group_id: @record.id).exists?
  end

  def is_a_member?
    UserGroup.where(user_id: user.id, group_id: @record.id).exists?
  end

  def is_a_leader?
    GroupLeader.where(user_id: user.id, group_id: @record.id).exists?
  end

  def has_group_leader_permissions?(permission)
    return false if !is_a_leader?
      @record.group_leaders.where(user_id: @user.id).where("#{permission} = true").exists?
  end

  def update?
    return true if manage?
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
    return true if basic_group_leader_permission?('global_calendar')
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
    return true if is_a_member? && @policy_group.groups_insights_manage?
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
    return true if is_a_member? && @policy_group.groups_layouts_manage?
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
    return true if is_a_member? && @policy_group.group_settings_manage?
  end

  class Scope < Scope
    def index?
      GroupPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id).all
      else
        scope.none
      end
    end
  end
end
