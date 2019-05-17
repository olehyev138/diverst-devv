class AddParentGroupIdToGroups < ActiveRecord::Migration[5.1]
  def up
    add_column :groups, :parent_id, :integer
  end
end
