class AnnualBudgetPolicy < GroupBasePolicy
  def base_index_permission
    'groups_budgets_index'
  end

  def base_create_permission
    'groups_budgets_request'
  end

  def base_manage_permission
    'groups_budgets_manage'
  end

  class Scope < Scope
    def group_base
      group.annual_budgets
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
