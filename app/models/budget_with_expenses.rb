class BudgetWithExpenses < Budget
  self.table_name = 'budgets_with_expenses'

  def readonly?
    true
  end
end
