class AddAvailableAmountToBudgets < ActiveRecord::Migration
  def change
    change_table :budgets do |t|
      t.decimal :available_amount, precision: 8, scale: 2, after: :agreed_amount
    end
  end
end
