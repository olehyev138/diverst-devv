class CreateSubGroupCategories < ActiveRecord::Migration
  def change
    create_table :sub_group_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
