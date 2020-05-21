class AddAutoArchiveSwitchToGroupsAndEnterprises < ActiveRecord::Migration
  def change
    add_column :groups, :auto_archive, :boolean, default: false
    add_column :enterprises, :auto_archive, :boolean, default: false
  end
end
