class ConvertAnnualBudgetKeysToBigInt < ActiveRecord::Migration[5.2]
  def change
    # Disable foreign key checks temporarily to switch columns to bigints
    execute 'SET FOREIGN_KEY_CHECKS = 0'

    remove_foreign_key "annual_budgets", "groups" if foreign_key_exists?("annual_budgets", "groups")
    remove_foreign_key "budgets", "annual_budgets" if foreign_key_exists?("budgets", "annual_budgets")
    remove_foreign_key "annual_budgets", column: "deprecated_enterprise_id" if foreign_key_exists?("annual_budgets", column: "deprecated_enterprise_id")
    remove_foreign_key "initiative_expenses", column: "deprecated_annual_budget_id" if foreign_key_exists?("initiative_expenses", column: "deprecated_annual_budget_id")
    remove_foreign_key "initiatives", column: "deprecated_annual_budget_id" if foreign_key_exists?("initiatives", column: "deprecated_annual_budget_id")

    # Primary Key
    change_column :annual_budgets, :id, :bigint, auto_increment: true

    # Foreign Key
    change_column :annual_budgets, :group_id, :bigint
    change_column :annual_budgets, :deprecated_enterprise_id, :bigint

    change_column :initiatives, :deprecated_annual_budget_id, :bigint
    change_column :budgets, :annual_budget_id, :bigint
    change_column :initiative_expenses, :deprecated_annual_budget_id, :bigint

    # Add back foreign keys
    add_foreign_key "annual_budgets", "groups"
    add_foreign_key "budgets", "annual_budgets"
    add_foreign_key "annual_budgets", "enterprises", column: "deprecated_enterprise_id"
    add_foreign_key "initiative_expenses", "annual_budgets", column: "deprecated_annual_budget_id"
    add_foreign_key "initiatives", "annual_budgets", column: "deprecated_annual_budget_id"
  end
end
