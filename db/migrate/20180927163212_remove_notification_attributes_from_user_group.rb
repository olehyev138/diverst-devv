class RemoveNotificationAttributesFromUserGroup < ActiveRecord::Migration[5.1]
  def change
  	remove_column :user_groups, :notifications_frequency
  	remove_column :user_groups, :notifications_date
  end
end
