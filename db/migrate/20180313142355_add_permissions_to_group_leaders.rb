class AddPermissionsToGroupLeaders < ActiveRecord::Migration
  def change
    # we need to ensure group_leaders who are not 'admins' have access only to groups
    # where the role is permitted
    
    add_column :group_leaders, :groups_budgets_index, :boolean, :null => false, :default => false
    add_column :group_leaders, :initiatives_manage,   :boolean, :null => false, :default => false
    add_column :group_leaders, :groups_manage,        :boolean, :null => false, :default => false
  end
end
