class AddTotalWeeklyPointsToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :total_weekly_points, :integer, default: 0
  end
end
