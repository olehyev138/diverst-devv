class AddNotificationsDateToUserGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :user_groups, :notifications_date, :integer, default: 1
  end
end
