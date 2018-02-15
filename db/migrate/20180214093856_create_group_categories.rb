class CreateGroupCategories < ActiveRecord::Migration
  def change
    create_table :group_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
