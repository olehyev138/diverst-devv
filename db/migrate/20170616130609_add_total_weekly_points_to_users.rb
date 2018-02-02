class AddTotalWeeklyPointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_weekly_points, :integer, default: 0
  end
end
