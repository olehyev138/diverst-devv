class BudgetPolicy < ApplicationPolicy
  def approve?
    return true if manage_all?
    @policy_group.budget_approval?
  end

  def decline?
    approve?
  end
end
