class AddEnableNotificationToUserGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :user_groups, :enable_notification, :boolean, default: true
  end
end
