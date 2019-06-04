class AddShareableTokenToMetricsDashboards < ActiveRecord::Migration[5.1]
  def change
    change_table :metrics_dashboards do |t|
      t.string :shareable_token
    end
  end
end
