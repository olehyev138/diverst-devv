class CreateGroupCategoryTypes < ActiveRecord::Migration
  def change
    create_table :group_category_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
