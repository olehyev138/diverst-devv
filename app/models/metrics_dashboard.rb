class MetricsDashboard < ActiveRecord::Base
  belongs_to :enterprise, inverse_of: :metrics_dashboards
  has_many :graphs, inverse_of: :metrics_dashboard
  has_and_belongs_to_many :segments
end
