class MetricsDashboardSerializer < ApplicationRecordSerializer
  attributes :id, :name, :permissions

  has_many :groups
  has_many :segments
  has_many :graphs
end
