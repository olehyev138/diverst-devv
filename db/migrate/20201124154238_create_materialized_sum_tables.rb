class CreateMaterializedSumTables < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_users_sums, id: false, force: true do |t|
      t.bigint :budget_user_id, primary_key: true
      t.decimal :spent, precision: 20, scale: 4
    end

    create_table :budget_items_sums, id: false, force: true do |t|
      t.bigint :budget_item_id, primary_key: true
      t.decimal :spent, precision: 20, scale: 4
      t.decimal :reserved, precision: 20, scale: 4
      t.decimal :user_estimates, precision: 20, scale: 4
      t.decimal :finalized_expenditures, precision: 20, scale: 4
    end

    create_table :budgets_sums, id: false, force: true do |t|
      t.bigint :budget_id, primary_key: true
      t.decimal :spent, precision: 20, scale: 4
      t.decimal :reserved, precision: 20, scale: 4
      t.decimal :user_estimates, precision: 20, scale: 4
      t.decimal :finalized_expenditures, precision: 20, scale: 4
      t.decimal :requested_amount, precision: 20, scale: 4
    end

    create_table :annual_budgets_sums, id: false, force: true do |t|
      t.bigint :annual_budget_id, primary_key: true
      t.decimal :spent, precision: 20, scale: 4
      t.decimal :reserved, precision: 20, scale: 4
      t.decimal :user_estimates, precision: 20, scale: 4
      t.decimal :finalized_expenditures, precision: 20, scale: 4
      t.decimal :requested_amount, precision: 20, scale: 4
      t.decimal :approved, precision: 20, scale: 4
    end
  end
end
