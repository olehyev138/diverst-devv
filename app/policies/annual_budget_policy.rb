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

  def index?
    super || BudgetPolicy.new(user, [group, Budget]).index?
  end

  def manage?
    BudgetPolicy.new(user, Budget).manage_all_budgets?
  end

  alias_method :reset_budgets?, :manage?

  class Scope < Scope
    def group_base
      group.all_annual_budgets
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
