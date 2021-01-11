class RenameAnnualBudgetEnterpriseId < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        remove_foreign_key :annual_budgets, column: :enterprise_id if foreign_key_exists?(:annual_budgets, column: :enterprise_id)
        remove_foreign_key :budgets, column: :group_id if foreign_key_exists?(:budgets, column: :group_id)
        remove_foreign_key :initiatives, column: :annual_budget_id if foreign_key_exists?(:initiatives, column: :annual_budget_id)
        remove_foreign_key :initiative_expenses, column: :annual_budget_id if foreign_key_exists?(:initiative_expenses, column: :annual_budget_id)
      end

      dir.down do
        add_foreign_key :initiative_expenses, :annual_budgets, column: :annual_budget_id
        add_foreign_key :initiatives, :annual_budgets, column: :annual_budget_id
        add_foreign_key :budgets, :groups, column: :group_id
        add_foreign_key :annual_budgets, :enterprises, column: :enterprise_id
      end
    end

    rename_column :annual_budgets, :enterprise_id, :deprecated_enterprise_id
    rename_column :budgets, :group_id, :deprecated_group_id
    rename_column :initiatives, :annual_budget_id, :deprecated_annual_budget_id
    rename_column :initiative_expenses, :annual_budget_id, :deprecated_annual_budget_id

    rename_column :annual_budgets, (column_exists?(:annual_budgets, :available) ? :available : :available_budget), :deprecated_available_budget
    rename_column :annual_budgets, (column_exists?(:annual_budgets, :approved) ? :approved : :approved_budget), :deprecated_approved_budget

    rename_column :annual_budgets, :leftover_money, :deprecated_leftover_money
    rename_column :annual_budgets, :expenses, :deprecated_expenses

    rename_column :budget_items, :available_amount, :deprecated_available_amount

    rename_column :groups, :annual_budget, :deprecated_annual_budget
    rename_column :groups, :leftover_money, :deprecated_leftover_money

    rename_column :initiatives, :actual_funding, :deprecated_actual_funding
  end
end
