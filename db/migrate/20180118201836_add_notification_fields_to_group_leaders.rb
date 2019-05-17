class AddNotificationFieldsToGroupLeaders < ActiveRecord::Migration[5.1]
  def up
    rename_column :group_leaders, :notifications_enabled, :pending_member_notifications_enabled
    add_column :group_leaders, :pending_comments_notifications_enabled, :boolean, default: false
    add_column :group_leaders, :pending_posts_notifications_enabled, :boolean, default: false
  end
end
