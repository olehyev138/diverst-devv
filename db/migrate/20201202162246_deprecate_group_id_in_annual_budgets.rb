class DeprecateGroupIdInAnnualBudgets < ActiveRecord::Migration[5.2]
  def change
    rename_column :annual_budgets, :group_id, :deprecated_group_id
  end
end
