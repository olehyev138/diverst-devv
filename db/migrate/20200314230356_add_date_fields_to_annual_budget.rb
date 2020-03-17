class AddDateFieldsToAnnualBudget < ActiveRecord::Migration
  def change
    add_column :annual_budgets, :start_date, :datetime 
    add_column :annual_budgets, :end_date, :datetime
  end
end
