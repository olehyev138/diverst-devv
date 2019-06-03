class AddTotalWeeklyPointsToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :total_weekly_points, :integer, default: 0
  end
end
