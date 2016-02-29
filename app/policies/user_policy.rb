class UserPolicy < ApplicationPolicy
  def index?
    @policy_group.global_settings_manage?
  end

  def create?
    @policy_group.global_settings_manage?
  end

  def update?
    @policy_group.global_settings_manage?
  end

  def destroy?
    @policy_group.global_settings_manage?
  end

  def join_or_leave_groups?
    return true if @record == @user
    return true if GroupPolicy.new(@record, @user).manage_members?
    false
  end
end
