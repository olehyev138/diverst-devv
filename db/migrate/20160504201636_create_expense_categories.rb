class CreateExpenseCategories < ActiveRecord::Migration
  def change
    create_table :expense_categories do |t|
      t.belongs_to :enterprise
      t.string :name
      t.attachment :icon

      t.timestamps
    end

    reversible do |direction|
      direction.up { remove_column :expenses, :category }
      direction.down { add_column :expenses, :category, :string }
    end

    change_table :expenses do |t|
      t.belongs_to :category
    end
  end
end
