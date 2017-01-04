class AddLeftoverMoneyToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.decimal :leftover_money, precision: 8, scale: 2, default: 0
    end
  end
end
