class AnnualBudgetDecorator < Draper::Decorator
  def spendings_percentage
    return 0 if annual_budget.expenses == 0

    percent_expenditure = (annual_budget.expenses.to_f / annual_budget.amount.to_f) * 100

    return 100 if percent_expenditure.nan? || percent_expenditure.infinite?

    percent_expenditure
  end
end
