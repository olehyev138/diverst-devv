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

  def visibility
    'group'
  end

  def update?
    false
  end

  def approve?
    manage_group_resource(base_manage_permission) ||
    manage_group_resource('budget_approval')
  end

  def index?
    super || approve?
  end

  alias_method :decline?, :approve?

  def manage_all_budgets?
    return true if user.policy_group.manage_all?

    user.policy_group.groups_budgets_manage? && user.policy_group.groups_manage?
  end

  def destroy?
    if @record.is_approved?
      false
    else
      @record.requester == @user || manage_all?
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
