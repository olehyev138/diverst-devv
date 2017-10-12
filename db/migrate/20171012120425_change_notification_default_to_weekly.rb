class ChangeNotificationDefaultToWeekly < ActiveRecord::Migration
  def change
    #Change default to 'weekly'
    change_column_default :user_groups, :notifications_frequency, 2
  end
end
