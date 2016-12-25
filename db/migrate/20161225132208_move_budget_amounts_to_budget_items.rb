class MoveBudgetAmountsToBudgetItems < ActiveRecord::Migration
  def change
    remove_column :budgets, :requested_amount, :decimal, precision: 8, scale: 2
    remove_column :budgets, :agreed_amount, :decimal, precision: 8, scale: 2
    remove_column :budgets, :available_amount, :decimal, precision: 8, scale: 2

    remove_column :budget_items, :estimated_price, :string #Why it was a string in the first place?
    add_column    :budget_items, :estimated_amount, :decimal, precision: 8, scale: 2
    add_column    :budget_items, :available_amount, :decimal, precision: 8, scale: 2
  end
end
