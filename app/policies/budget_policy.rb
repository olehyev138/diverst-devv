class BudgetPolicy < GroupBasePolicy
  def base_index_permission
    'groups_budgets_request'
  end

  def base_create_permission
    'groups_budgets_request'
  end

  def base_manage_permission
    'groups_budgets_manage'
  end

  def update?
    false
  end

  def approve?
    policy_group.budget_approval ||
    manage_group_resource(base_manage_permission) ||
    manage_group_resource('budget_approval')
  end

  def decline?
    approve?
  end

  def manage_all_budgets?
    return true if user.policy_group.manage_all?

    user.policy_group.groups_budgets_manage? && user.policy_group.groups_manage?
  end

  def destroy?
    if @record.is_approved?
      manage_all? || policy_group.enterprise_manage?
    else
      @record.requester == @user
    end
  end

  class Scope < Scope
    def group_base
      group.budgets
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
