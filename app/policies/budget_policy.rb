class BudgetPolicy < ApplicationPolicy
  def approve?
    #bTODO implement this
    true
  end

  def reject?
    approve?
  end
end
