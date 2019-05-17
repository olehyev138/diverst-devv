class MetricsDashboardsSegment < ApplicationRecord
  belongs_to :segment
  belongs_to :metrics_dashboard
end
