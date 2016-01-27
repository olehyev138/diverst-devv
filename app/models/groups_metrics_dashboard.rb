class GroupsMetricsDashboard < ActiveRecord::Base
  belongs_to :group
  belongs_to :metrics_dashboard
end
