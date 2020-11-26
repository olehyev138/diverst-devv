class AnnualBudgetWithExpenses < AnnualBudget
  self.table_name = 'annual_budgets_with_expenses'

  def expenses; spent end
  def estimated; user_estimates end

  def readonly?
    true
  end
end
