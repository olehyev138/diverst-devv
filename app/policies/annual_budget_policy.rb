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

  def group_of(object)
    g = Group.find(params[:group_id]) || object.group
    return nil unless g.is_child_of(object.budget_head) || g == object.budget_head

    g
  end

  def index?
    super || BudgetPolicy.new(user, [group, Budget]).index?
  end

  def manage?
    super || BudgetPolicy.new(user, Budget).manage_all_budgets?
  end

  alias_method :reset_budgets?, :manage?

  class Scope < Scope
    def group_base
      group.all_annual_budgets
    end

    def resolve
      if group.present?
        super(policy.base_index_permission)
      else
        scope.none
      end
    end
  end
end
