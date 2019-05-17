class AddOwnerToMetricsDashboards < ActiveRecord::Migration[5.1]
  def change
    change_table :metrics_dashboards do |t|
      t.belongs_to :owner
    end
  end
end
