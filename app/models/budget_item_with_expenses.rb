class BudgetItemWithExpenses < BudgetItem
  self.table_name = 'budget_items_with_expenses'
  def readonly?
    true
  end
end
