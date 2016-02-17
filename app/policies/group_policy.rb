class GroupPolicy < ApplicationPolicy
  def index?
    @policy_group.groups_index?
  end

  def create?
    @policy_group.groups_create?
  end

  def update?
    return true if @policy_group.groups_manage?
    return true if @record.owner == @user
    @record.managers.exists?(user.id)
  end

  def manage_members?
    return true if @policy_group.groups_manage?
    return true if @record.owner == @user
    @record.managers.exists?(user.id)
  end

  def destroy?
    return true if @policy_group.groups_manage?
    @record.owner == @user
  end
end
