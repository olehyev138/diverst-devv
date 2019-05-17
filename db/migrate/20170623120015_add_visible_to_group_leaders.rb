class AddVisibleToGroupLeaders < ActiveRecord::Migration[5.1]
  def change
    add_column :group_leaders, :visible, :boolean, default: true
  end
end
