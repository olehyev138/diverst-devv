class AddAnnualBudgetToErg < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.decimal :annual_budget, precision: 8, scale: 2, after: 'budget_manager_email'
    end
  end
end