class UserRolePolicy < ApplicationPolicy
  def index?
    @policy_group.users_index?
  end

  def new?
    @policy_group.users_manage?
  end

  def create?
    @policy_group.users_manage?
  end

  def update?
    @policy_group.users_manage?
  end

  def destroy?
    @policy_group.users_manage?
  end
end
