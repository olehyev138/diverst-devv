class RenameGroupToGroupsInGroupsMetricsDashboards < ActiveRecord::Migration[5.1]
  def change
    change_table :groups_metrics_dashboards do |t|
      t.rename :groups_id, :group_id
    end
  end
end
