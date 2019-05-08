class UserRolePolicy < ApplicationPolicy
  def index?
    return true if create?
    return true if basic_group_leader_permission?('users_index')

    @policy_group.users_index?
  end

  def new?
    create?
  end

  def create?
    return true if manage_all?
    return true if basic_group_leader_permission?('users_manage')

    @policy_group.users_manage?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
