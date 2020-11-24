class CreateBudgetUsersWithExpenses < ActiveRecord::Migration[5.2]
  def change
    create_view :budget_users_with_expenses
  end
end
