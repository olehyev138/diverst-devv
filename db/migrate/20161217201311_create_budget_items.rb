class CreateBudgetItems < ActiveRecord::Migration
  def change
    create_table :budget_items do |t|
      t.integer :budget_id

      t.string :title

      t.string :estimated_price, default: 0
      t.date :estimated_date

      t.boolean :is_done, default: false

      t.timestamps null: false
    end
  end
end
