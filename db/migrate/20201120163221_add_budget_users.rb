class AddBudgetUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :budget_users do |t|
      t.belongs_to :budgetable, polymorphic: true
      t.belongs_to :budget_item

      t.timestamps null: false
    end

    add_reference :initiative_expenses, :budget_user, index: true
  end
end
