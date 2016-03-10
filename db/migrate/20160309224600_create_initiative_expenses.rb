class CreateInitiativeExpenses < ActiveRecord::Migration
  def change
    create_table :initiative_expenses do |t|
      t.string :description
      t.integer :amount

      t.belongs_to :owner
      t.belongs_to :initiative

      t.timestamps null: false
    end
  end
end
