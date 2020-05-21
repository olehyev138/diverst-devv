class AddGroupCategoryTypeIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_category_type_id, :integer, default: nil
  end
end
