class AddGroupCategoryTypeIdToGroups < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :group_category_type_id, :integer, default: nil
  end
end
