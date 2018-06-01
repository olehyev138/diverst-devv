class PolicyGroupTemplatePolicy < ApplicationPolicy
  def index?
    @policy_group.permissions_manage?
  end

  def new?
    @policy_group.permissions_manage?
  end

  def create?
    @policy_group.permissions_manage?
  end

  def update?
    @policy_group.permissions_manage?
  end

  def destroy?
    @policy_group.permissions_manage?
  end
end
