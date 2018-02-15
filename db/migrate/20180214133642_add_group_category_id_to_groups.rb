class AddGroupCategoryIdToGroups < ActiveRecord::Migration
  def change
  	add_column :groups, :group_category_id, :integer, default: nil
  end
end
