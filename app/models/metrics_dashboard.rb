class MetricsDashboard < ActiveRecord::Base
  belongs_to :enterprise, inverse_of: :metrics_dashboards
  has_many :graphs, inverse_of: :metrics_dashboard
  has_and_belongs_to_many :segments

  # Returns a query to the list of employees targeted by the dashboard
  def target
    if segments.empty?
      enterprise.employees.for_segments(segments)
    else
      enterprise.employees
    end
  end

  def percentage_of_total
    (target.count / enterprise.employees.count * 100).ceil
  end
end
