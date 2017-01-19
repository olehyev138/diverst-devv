class ResourcePolicy < ApplicationPolicy
  def index?
    @policy_group.enterprise_resources_index?
  end

  def create?
    @policy_group.enterprise_resources_create?
  end

  def edit?
    @policy_group.enterprise_resources_manage?
  end

  def destroy?
    edit?
  end
end
