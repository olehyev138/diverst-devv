class MetricsDashboardsSegment < ActiveRecord::Base
  belongs_to :segment
  belongs_to :metric_dashboard
end