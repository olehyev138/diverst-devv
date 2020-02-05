class BudgetItemPolicy < GroupBasePolicy
  def base_index_permission
    'initiatives_create'
  end

  def base_create_permission
    'groups_budgets_request'
  end

  def base_manage_permission
    'groups_budgets_manage'
  end

  def close_budget?
    record.budget.requester == user || update?
  end

  class Scope < Scope
    def group_base
      group.current_budget_items
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
