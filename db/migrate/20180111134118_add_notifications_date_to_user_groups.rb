class AddNotificationsDateToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :notifications_date, :integer, default: 1
  end
end
