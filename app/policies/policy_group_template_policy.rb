class PolicyGroupTemplatePolicy < ApplicationPolicy
  def index?
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
