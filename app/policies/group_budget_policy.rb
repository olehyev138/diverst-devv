class GroupBudgetPolicy < GroupBasePolicy
  
    def base_index_permission
      "groups_budgets_index"
    end
    
    def base_create_permission
      "groups_budgets_request"
    end
    
    def approve?
      return true if update?
      @policy_group.budget_approval?
    end
    
    def manage_all_budgets?
      return true if user.policy_group.manage_all?
      user.policy_group.groups_budgets_manage? && user.policy_group.groups_manage?
    end
    
    def base_manage_permission
      "groups_budgets_manage"
    end
end