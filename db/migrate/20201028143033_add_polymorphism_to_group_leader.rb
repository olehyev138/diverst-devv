class AddPolymorphismToGroupLeader < ActiveRecord::Migration[5.2]
  def up
    remove_foreign_key 'group_leaders', 'groups'
    rename_column :group_leaders, :group_id, :leader_of_id
    add_column :group_leaders, :leader_of_type, :string, after: :leader_of_id

    GroupLeader.column_reload!
    GroupLeader.where(leader_of_type: nil).update_all(leader_of_type: 'Group')
  end

  def down
    remove_column :group_leaders, :leader_of_type
    rename_column :group_leaders, :leader_of_id, :group_id
    add_foreign_key 'group_leaders', 'groups', column: 'group_id'
  end
end
