class UndeprecateEnterpriseIdInAnnualBudgets < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        remove_foreign_key :annual_budgets, column: :deprecated_enterprise_id
      end
      dir.down do
        add_foreign_key :annual_budgets, :enterprises, column: :deprecated_enterprise_id
      end
    end
    rename_column :annual_budgets, :deprecated_enterprise_id, :enterprise_id

    up_only do
      AnnualBudget.column_reload!
      AnnualBudget.find_each do |ab|
        ab.update(enterprise: ab.budget_head&.enterprise) if ab.enterprise_id.blank?
      end
    end
  end
end
