class RemoveNotificationAttributesFromUserGroup < ActiveRecord::Migration
  def change
    remove_column :user_groups, :notifications_frequency
    remove_column :user_groups, :notifications_date
  end
end
