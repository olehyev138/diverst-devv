class CreateAnnualBudgetsWithExpenses < ActiveRecord::Migration[5.2]
  def change
    create_view :annual_budgets_with_expenses
  end
end
