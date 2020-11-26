class BudgetItemWithExpenses < BudgetItem
  self.table_name = 'budget_items_with_expenses'

  def expenses; spent end
  def estimated; user_estimates end

  def readonly?
    true
  end
end
