class ChangeBudgetsToDecimal < ActiveRecord::Migration[5.2]
  def up
    change_column :annual_budgets, :amount,                       :decimal, precision: 20, scale: 4, default: 0, null: false
    change_column :annual_budgets, :deprecated_available_budget,  :decimal, precision: 20, scale: 4
    change_column :annual_budgets, :deprecated_approved_budget,   :decimal, precision: 20, scale: 4
    change_column :annual_budgets, :deprecated_expenses,          :decimal, precision: 20, scale: 4
    change_column :annual_budgets, :deprecated_leftover_money,    :decimal, precision: 20, scale: 4

    change_column :budget_items, :estimated_amount,               :decimal, precision: 20, scale: 4, default: 0, null: false
    change_column :budget_items, :deprecated_available_amount,    :decimal, precision: 20, scale: 4

    change_column :expenses, :price,                              :decimal, precision: 20, scale: 4

    change_column :initiative_expenses, :amount,                  :decimal, precision: 20, scale: 4, default: 0, null: false

    change_column :initiatives, :estimated_funding,               :decimal, precision: 20, scale: 4, default: 0, null: false
    change_column :initiatives, :deprecated_actual_funding,       :decimal, precision: 20, scale: 4

    change_column :groups, :deprecated_annual_budget,             :decimal, precision: 20, scale: 4
    change_column :groups, :deprecated_leftover_money,            :decimal, precision: 20, scale: 4
  end

  def down
    change_column :annual_budgets, :amount,                       :decimal, precision: 10, default: "0", null: true
    change_column :annual_budgets, :deprecated_available_budget,  :decimal, precision: 10, default: "0"
    change_column :annual_budgets, :deprecated_approved_budget,   :decimal, precision: 10, default: "0"
    change_column :annual_budgets, :deprecated_expenses,          :decimal, precision: 10, default: "0"
    change_column :annual_budgets, :deprecated_leftover_money,    :decimal, precision: 10, default: "0"

    change_column :budget_items, :estimated_amount,               :decimal, precision: 8, scale: 2, default: nil, null: true
    change_column :budget_items, :deprecated_available_amount,    :decimal, precision: 8, scale: 2, default: "0.0"

    change_column :expenses, :price,                              :integer

    change_column :initiative_expenses, :amount,                  :decimal, precision: 8, scale: 2, default: "0.0", null: true

    change_column :initiatives, :estimated_funding,               :decimal, precision: 8, scale: 2, default: "0.0", null: false
    change_column :initiatives, :deprecated_actual_funding,       :integer

    change_column :groups, :deprecated_annual_budget,             :decimal, precision: 8, scale: 2
    change_column :groups, :deprecated_leftover_money,            :decimal, precision: 8, scale: 2, default: "0.0"
  end
end
