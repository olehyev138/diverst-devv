class AddGroupCategoryTypeIdToGroupCategories < ActiveRecord::Migration
  def change
  	add_column :group_categories, :group_category_type_id, :integer, default: nil
  end
end
