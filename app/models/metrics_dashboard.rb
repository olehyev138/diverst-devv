class MetricsDashboard < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :enterprise, inverse_of: :metrics_dashboards
  belongs_to :owner, class_name: "User"
  has_many :graphs
  has_many :metrics_dashboards_segments
  has_many :segments, through: :metrics_dashboards_segments
  has_many :groups_metrics_dashboards
  has_many :groups, through: :groups_metrics_dashboards

  validates_presence_of :name, :message => "Metrics Dashboard name is required"
  validates_presence_of :groups, :message => "Please select a group"

  def update_shareable_token
    if shareable_token.nil?
      self.shareable_token = SecureRandom.urlsafe_base64
      return self.save
    else
      return shareable_token
    end
  end

  # Returns a query to the list of users targeted by the dashboard
  def target
    enterprise.users.for_segments(segments).for_groups(groups).active
  end

  def graphs_population
    target
  end

  def percentage_of_total
    return 0 if enterprise.users.count == 0
    return 100 if target.count > enterprise.users.count
    (target.count.to_f / enterprise.users.count * 100).round
  end

  # Defines which fields will be usable when creating graphs
  def graphable_fields(admin)
    admin.enterprise.graph_fields.select do |field|
      field.type != 'TextField'
    end
  end
end
