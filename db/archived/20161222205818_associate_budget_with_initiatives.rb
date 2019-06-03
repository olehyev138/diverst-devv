class AssociateBudgetWithInitiatives < ActiveRecord::Migration[5.1]
  def change
    change_table :initiatives do |t|
      t.integer :budget_item_id
    end
  end
end
