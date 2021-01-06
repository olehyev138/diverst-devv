class AddYearAndQuarterToAnnualBudgets < ActiveRecord::Migration[5.2]
  def change
    add_column :annual_budgets, :year, :integer
    add_column :annual_budgets, :quarter, :integer
  end
end
