class AddLastGroupNotificationDateToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_group_notification_date, :datetime, default: nil
  end
end
