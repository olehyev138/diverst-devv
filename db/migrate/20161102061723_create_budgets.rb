class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :subject_id
      t.string :subject_type

      t.text :description

      t.decimal :requested_amount, :precision => 8, :scale => 2
      t.decimal :agreed_amount, :precision => 8, :scale => 2

      t.boolean :is_approved, default: false
      t.timestamps null: false
    end
  end
end
