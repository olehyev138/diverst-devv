class BudgetManager
  def initialize(budget)
    @budget = budget
  end

  def approve(approver)
    @budget.budget_items.each do |bi|
      bi.approve!
    end
    @budget.update(approver: approver, is_approved: true)
    AnnualBudgetManager.new(@budget.group).approve
    BudgetMailer.budget_approved(@budget).deliver_later if @budget.requester
  end

  def decline(approver)
    @budget.update(approver: approver, is_approved: false)
    BudgetMailer.budget_declined(@budget).deliver_later if @budget.requester
  end
end
