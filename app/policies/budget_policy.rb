class BudgetPolicy < ApplicationPolicy
  def approve?
    @policy_group.budget_approval?
  end

  def decline?
    approve?
  end
end
