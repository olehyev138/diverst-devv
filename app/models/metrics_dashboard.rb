class MetricsDashboard < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise, inverse_of: :metrics_dashboards
  belongs_to :owner, class_name: 'User'
  has_many :graphs, dependent: :destroy
  has_many :metrics_dashboards_segments, dependent: :destroy
  has_many :segments, through: :metrics_dashboards_segments
  has_many :groups_metrics_dashboards, dependent: :destroy
  has_many :groups, through: :groups_metrics_dashboards
  has_many :shared_metrics_dashboards, dependent: :destroy, validate: false
  has_many :shared_users, through: :shared_metrics_dashboards, source: :user

  validates_length_of :shareable_token, maximum: 191
  validates_length_of :name, maximum: 191
  validates_presence_of :name, message: 'Metrics Dashboard name is required'
  validates_presence_of :groups, message: 'Please select a group'

  scope :with_shared_dashboards, -> (user_id) {
    joins('LEFT JOIN shared_metrics_dashboards ON metrics_dashboards.id = shared_metrics_dashboards.metrics_dashboard_id')
    .where('shared_metrics_dashboards.user_id = ? OR metrics_dashboards.owner_id = ?', user_id, user_id).uniq
  }

  def is_user_shared?(user)
    shared_users.include?(user)
  end

  def update_shareable_token
    if shareable_token.nil?
      self.shareable_token = SecureRandom.urlsafe_base64
      self.save
    else
      shareable_token
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
    return 0 if enterprise.users.size == 0
    return 100 if target.count > enterprise.users.size

    (target.count.to_f / enterprise.users.size * 100).round
  end

  # Defines which fields will be usable when creating graphs
  def graphable_fields(admin)
    admin.enterprise.graph_fields.select do |field|
      field.type != 'TextField'
    end
  end
end
