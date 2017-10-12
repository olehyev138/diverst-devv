class AddNotificationsEnabledToGroupLeaders < ActiveRecord::Migration
  def change
    add_column :group_leaders, :notifications_enabled, :boolean, :default => false
  end
end
