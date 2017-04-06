class BudgetManager
  def initialize(budget)
    @budget = budget
  end

  def approve(approver)
    @budget.budget_items.each do |bi|
      bi.approve!
    end
    @budget.update(approver: approver, is_approved: true)
    #send an email
  end

  def decline(approver)
    @budget.update(approver: approver, is_approved: false)
    #send an email
  end
end
