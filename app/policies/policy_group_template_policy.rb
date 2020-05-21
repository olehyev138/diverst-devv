class PolicyGroupTemplatePolicy < ApplicationPolicy
  def index?
    return true if manage_all?
    return true if basic_group_leader_permission?('permissions_manage')

    @policy_group.permissions_manage?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end
end
