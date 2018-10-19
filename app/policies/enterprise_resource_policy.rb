class EnterpriseResourcePolicy < ApplicationPolicy
  def index?
    return true if create?
    @policy_group.enterprise_resources_index?
  end

  def create?
    return true if update?
    @policy_group.enterprise_resources_create?
  end

  def edit?
    update?
  end

  def update?
    @policy_group.enterprise_resources_manage?
  end

  def destroy?
    update?
  end
end
