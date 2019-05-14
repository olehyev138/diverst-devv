class ExpenseCategoryPolicy < ApplicationPolicy
  def index?
    return true if manage_all?
    return true if basic_group_leader_permission?('campaigns_manage')

    @policy_group.campaigns_manage?
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

  class Scope < Scope
    def index?
      ExpenseCategoryPolicy.new(user, nil).index?
    end

    def resolve
      if index?
        scope.where(enterprise_id: user.enterprise_id)
      else
        scope.none
      end
    end
  end
end
