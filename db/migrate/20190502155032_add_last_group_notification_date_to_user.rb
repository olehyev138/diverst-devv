class AddLastGroupNotificationDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_group_notification_date, :datetime, default: nil
  end
end
