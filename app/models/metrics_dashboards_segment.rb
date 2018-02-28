class MetricsDashboardsSegment < ActiveRecord::Base
  belongs_to :segment
  belongs_to :metrics_dashboard
end