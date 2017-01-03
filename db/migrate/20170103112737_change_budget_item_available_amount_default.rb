class ChangeBudgetItemAvailableAmountDefault < ActiveRecord::Migration
  def change
    change_column :budget_items, :available_amount, :decimal, default: 0
  end
end
