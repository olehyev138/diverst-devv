class DeprecateGroupIdInAnnualBudgets < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :annual_budgets, column: :group_id
    remove_index :annual_budgets, name: 'index_annual_budgets_on_group_id'
    rename_column :annual_budgets, :group_id, :deprecated_group_id
  end
end
