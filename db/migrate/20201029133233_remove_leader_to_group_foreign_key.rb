class RemoveLeaderToGroupForeignKey < ActiveRecord::Migration[5.2]
  def up
    remove_foreign_key 'group_leaders', 'groups'
  end

  def down
    add_foreign_key 'group_leaders', 'groups', column: 'leader_of_id'
  end
end
