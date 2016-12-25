class AssociateBudgetWithInitiatives < ActiveRecord::Migration
  def change
    change_table :initiatives do |t|
      t.integer :budget_item_id
    end
  end
end
