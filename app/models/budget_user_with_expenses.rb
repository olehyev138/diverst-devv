class BudgetUserWithExpenses < BudgetUser
  self.table_name = 'budget_users_with_expenses'
  def readonly?
    true
  end
end
