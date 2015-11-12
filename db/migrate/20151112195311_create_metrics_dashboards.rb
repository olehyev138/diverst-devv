class CreateMetricsDashboards < ActiveRecord::Migration
  def change
    create_table :metrics_dashboards do |t|
      t.belongs_to :enterprise
      t.string :name

      t.timestamps null: false
    end
  end
end
