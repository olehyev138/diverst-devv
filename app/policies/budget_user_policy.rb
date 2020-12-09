class BudgetUserPolicy < ApplicationPolicy
  def index
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  class Scope < Scope
    def resolve
      if policy.index?
        scope.joins(:group).where(groups: { enterprise_id: user.enterprise_id })
      else
        scope.none
      end
    end
  end
end
