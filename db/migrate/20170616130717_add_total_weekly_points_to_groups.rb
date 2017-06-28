class AddTotalWeeklyPointsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :total_weekly_points, :integer, default: 0
  end
end
