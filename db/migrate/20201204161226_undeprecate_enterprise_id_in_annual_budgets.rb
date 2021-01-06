class UndeprecateEnterpriseIdInAnnualBudgets < ActiveRecord::Migration[5.2]
  def change
    rename_column :annual_budgets, :deprecated_enterprise_id, :enterprise_id
    up_only do
      AnnualBudget.column_reload!
      AnnualBudget.find_each do |ab|
        ab.update(enterprise: ab.budget_head.enterprise) if ab.enterprise_id.blank?
      end
    end
  end
end
