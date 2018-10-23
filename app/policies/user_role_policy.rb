class UserRolePolicy < ApplicationPolicy
  def index?
    @policy_group.users_index?
  end

  def new?
    create?
  end

  def create?
    return true if manage_all?
    @policy_group.users_manage?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
