class DeprecateGroupIdInAnnualBudgets < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        remove_foreign_key :annual_budgets, column: :group_id
      end
      dir.down do
        add_foreign_key :annual_budgets, :groups, column: :group_id
      end
    end
    rename_column :annual_budgets, :group_id, :deprecated_group_id
  end
end
