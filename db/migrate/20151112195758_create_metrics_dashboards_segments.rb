class CreateMetricsDashboardsSegments < ActiveRecord::Migration
  def change
    create_table :metrics_dashboards_segments do |t|
      t.belongs_to :metrics_dashboard
      t.belongs_to :segment
    end
  end
end
