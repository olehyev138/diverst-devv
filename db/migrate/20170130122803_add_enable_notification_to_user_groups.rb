class AddEnableNotificationToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :enable_notification, :boolean, default: true
  end
end
