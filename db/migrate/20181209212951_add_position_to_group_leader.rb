class AddPositionToGroupLeader < ActiveRecord::Migration
  def up
    add_column :group_leaders, :position, :integer

    GroupLeader.find_each.with_index(0) do |group_leader, index|
      group_leader.update_column :position, index
    end
  end

  def down
    remove_column :group_leaders, :position, :integer
  end
end
