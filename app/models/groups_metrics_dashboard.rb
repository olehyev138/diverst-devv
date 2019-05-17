class GroupsMetricsDashboard < ApplicationRecord
  belongs_to :group
  belongs_to :metrics_dashboard
end
