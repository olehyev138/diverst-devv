class RenameAnnualBudgetEnterpriseId < ActiveRecord::Migration[5.2]
  def change
    rename_column :annual_budgets, :enterprise_id, :deprecated_enterprise_id
    rename_column :budgets, :group_id, :deprecated_group_id
    rename_column :initiatives, :annual_budget_id, :deprecated_annual_budget_id
    rename_column :initiative_expenses, :annual_budget_id, :deprecated_annual_budget_id

    rename_column :annual_budgets, :available_budget, :deprecated_available_budget
    rename_column :annual_budgets, :approved_budget, :deprecated_approved_budget
    rename_column :annual_budgets, :leftover_money, :deprecated_leftover_money
    rename_column :annual_budgets, :expenses, :deprecated_expenses

    rename_column :budget_items, :available_amount, :deprecated_available_amount

    rename_column :groups, :annual_budget, :deprecated_annual_budget
    rename_column :groups, :leftover_money, :deprecated_leftover_money

    rename_column :initiatives, :actual_funding, :deprecated_actual_funding
  end
end
