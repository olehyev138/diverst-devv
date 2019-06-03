class ChangeBudgetItemAvailableAmountPrecison < ActiveRecord::Migration[5.1]
  def change
    change_column :budget_items, :available_amount, :decimal, default: 0, precision: 8, scale: 2
  end
end
