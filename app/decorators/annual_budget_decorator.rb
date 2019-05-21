class AnnualBudgetDecorator < Draper::Decorator
  def spendings_percentage
    return 0 if  annual_budget.amount == 0

    (annual_budget.expenses.to_f / annual_budget.amount.to_f) * 100
  end
end 