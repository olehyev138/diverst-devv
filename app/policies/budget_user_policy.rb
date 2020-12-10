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

  def finish_expenses?
    budgetable_policy = Pundit::PolicyFinder.new(record.budgetable).policy
    raise Pundit::NotAuthorizedError, query: action_name, record: item, policy: policy if budgetable_policy.blank?

    budgetable_policy.new(user, record.budgetable, params).update?
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
