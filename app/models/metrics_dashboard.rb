class MetricsDashboard < ActiveRecord::Base
  belongs_to :enterprise, inverse_of: :metrics_dashboards
  has_many :graphs, as: :collection
  has_and_belongs_to_many :segments
  has_and_belongs_to_many :groups

  # Returns a query to the list of employees targeted by the dashboard
  def target
    if segments.empty?
      enterprise.employees
    else
      enterprise.employees.for_segments(segments)
    end
  end

  def graphs_population
    target
  end

  def percentage_of_total
    (target.count.to_f / enterprise.employees.count * 100).ceil
  end

  # Defines which fields will be usable when creating graphs
  def graphable_fields(admin)
    admin.enterprise.fields
  end
end
