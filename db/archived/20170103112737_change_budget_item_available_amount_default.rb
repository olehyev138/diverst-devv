class ChangeBudgetItemAvailableAmountDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :budget_items, :available_amount, :decimal, default: 0
  end
end
