class ChangeColumnTypeFromIntegerToDecimal < ActiveRecord::Migration[5.2]
  def change
  	change_column :initiative_expenses, :amount, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
