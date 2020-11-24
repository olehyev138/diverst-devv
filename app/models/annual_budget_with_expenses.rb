class AnnualBudgetWithExpenses < AnnualBudget
  self.table_name = 'annual_budgets_with_expenses'

  def readonly?
    true
  end
end
