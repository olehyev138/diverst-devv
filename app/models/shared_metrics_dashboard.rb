class SharedMetricsDashboard < BaseClass
  belongs_to :user
  belongs_to :metrics_dashboard

  validates_presence_of :user_id
  validates_presence_of :metrics_dashboard_id
end
