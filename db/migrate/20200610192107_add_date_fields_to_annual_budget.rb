class AddDateFieldsToAnnualBudget < ActiveRecord::Migration[5.2]
  def change
    add_column :annual_budgets, :start_date, :datetime
    add_column :annual_budgets, :end_date, :datetime
  end
end
