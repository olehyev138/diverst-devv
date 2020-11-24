class CreateBudgetsWithExpenses < ActiveRecord::Migration[5.2]
  def change
    create_view :budgets_with_expenses
  end
end
