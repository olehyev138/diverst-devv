class BudgetPolicy < ApplicationPolicy
  def approve?
    @policy_group.budget_approval == true
  end

  def decline?
    approve?
  end
end
