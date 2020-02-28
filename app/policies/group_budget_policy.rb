class GroupBudgetPolicy < GroupBasePolicy
  def base_index_permission
    'groups_budgets_index'
  end

  def base_create_permission
    'groups_budgets_request'
  end

  def base_manage_permission
    'groups_budgets_manage'
  end

  def approve?
    return true if update?
    return true if basic_group_leader_permission?('budget_approval')

    user.policy_group.budget_approval?
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
      admin? ? true : false
    else
      @record.requester == @user ? true : false
    end
  end
end
