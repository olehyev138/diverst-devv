class AddParentGroupIdToGroups < ActiveRecord::Migration
  def up
    add_column :groups, :parent_id, :integer
  end
end
