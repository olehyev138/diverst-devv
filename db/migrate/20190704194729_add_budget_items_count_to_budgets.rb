class AddBudgetItemsCountToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :budget_items_count, :integer

    Budget.find_each do |budget|
      Budget.reset_counters(budget.id, :budget_items)
    end
  end
end
