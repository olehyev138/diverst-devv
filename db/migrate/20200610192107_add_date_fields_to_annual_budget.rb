class AddDateFieldsToAnnualBudget < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :annual_budgets, :start_date
      add_column :annual_budgets, :start_date, :datetime
    end

    unless column_exists? :annual_budgets, :end_date
      add_column :annual_budgets, :end_date, :datetime
    end
  end
end
