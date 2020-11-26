class BudgetWithExpenses < Budget
  self.table_name = 'budgets_with_expenses'

  has_many :budget_items, class_name: 'BudgetItemWithExpenses', foreign_key: primary_key

  def available_amount; available end

  def readonly?
    true
  end
end
