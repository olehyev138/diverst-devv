class AddNotificationsEnabledToGroupLeaders < ActiveRecord::Migration[5.1]
  def change
    add_column :group_leaders, :notifications_enabled, :boolean, :default => false
  end
end
