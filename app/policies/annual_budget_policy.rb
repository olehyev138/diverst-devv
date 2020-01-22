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
    def index?
      AnnualBudgetPolicy.new(user, nil).index?
    end

    def resolve
      super('groups_budgets_index')
    end
  end
end
