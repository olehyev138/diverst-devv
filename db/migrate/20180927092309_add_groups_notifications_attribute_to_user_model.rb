class AddGroupsNotificationsAttributeToUserModel < ActiveRecord::Migration
  def change
  	add_column :users, :groups_notifications_frequency, :integer, default: 2
  	add_column :users, :groups_notifications_date, :integer, default: 5
  end
end
