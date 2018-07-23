class AddBudgetDeclineReasonToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :budget_decline_reason, :string
  end
end
