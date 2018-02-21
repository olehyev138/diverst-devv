class ChangeDefaultWeeklyDate < ActiveRecord::Migration
  def change
    change_column_default :user_groups, :notifications_date, 5
  end
end
