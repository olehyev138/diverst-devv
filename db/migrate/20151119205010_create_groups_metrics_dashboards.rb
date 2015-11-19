class CreateGroupsMetricsDashboards < ActiveRecord::Migration
  def change
    create_table :groups_metrics_dashboards do |t|
      t.belongs_to :groups
      t.belongs_to :metrics_dashboard
    end
  end
end
