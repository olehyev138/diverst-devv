class CreateMaterializedSumTables < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_users_sums do |t|
      t.belongs_to :budget_user
      t.decimal :spent, precision: 20, scale: 4
    end

    create_table :budget_items_sums do |t|
      t.belongs_to :budget_item
      t.decimal :spent, precision: 20, scale: 4
      t.decimal :reserved, precision: 20, scale: 4
      t.decimal :finalized_expenditures, precision: 20, scale: 4
    end

    create_table :budgets_sums do |t|
      t.belongs_to :budget
      t.decimal :spent, precision: 20, scale: 4
      t.decimal :reserved, precision: 20, scale: 4
      t.decimal :requested_amount, precision: 20, scale: 4
      t.decimal :available, precision: 20, scale: 4
      t.decimal :unspent, precision: 20, scale: 4
    end

    create_table :annual_budgets_sums do |t|
      t.belongs_to :annual_budget
      t.decimal :spent, precision: 20, scale: 4
      t.decimal :reserved, precision: 20, scale: 4
      t.decimal :requested_amount, precision: 20, scale: 4
      t.decimal :available, precision: 20, scale: 4
      t.decimal :approved, precision: 20, scale: 4
      t.decimal :unspent, precision: 20, scale: 4
    end
  end
end
