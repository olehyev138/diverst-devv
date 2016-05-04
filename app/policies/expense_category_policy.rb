class ExpenseCategoryPolicy < ApplicationPolicy
  def index?
    @policy_group.campaigns_manage?
  end

  def create?
    @policy_group.campaigns_manage?
  end

  def update?
    return true if @policy_group.campaigns_manage?
  end

  def destroy?
    return true if @policy_group.campaigns_manage?
  end
end
