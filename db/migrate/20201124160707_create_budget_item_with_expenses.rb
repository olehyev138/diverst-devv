class CreateBudgetItemWithExpenses < ActiveRecord::Migration[5.2]
  def change
    create_view :budget_items_with_expenses
  end
end
