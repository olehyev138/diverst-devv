class AddVisibleToGroupLeaders < ActiveRecord::Migration
  def change
    add_column :group_leaders, :visible, :boolean, default: true
  end
end
