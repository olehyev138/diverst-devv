class CreateSharedMetricsDashboard < ActiveRecord::Migration[5.1]
  def change
    create_table :shared_metrics_dashboards do |t|
      t.references :user, index: true, foreign_key: true
      t.references :metrics_dashboard, index: true, foreign_key: true
    end
  end
end
