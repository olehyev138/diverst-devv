class AddGroupCategoryTypeIdToGroupCategories < ActiveRecord::Migration[5.1]
  def change
  	add_column :group_categories, :group_category_type_id, :integer, default: nil
  end
end
