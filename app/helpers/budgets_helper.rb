module BudgetsHelper
  def requester_name(budget)
    budget.requester ? budget.requester.try(:name).to_s : 'Unknown'
  end

  def approver_name(budget)
    budget.approver ? budget.approver.try(:name).to_s : 'Unknown'
  end
end
