class MetricsDashboardSerializer < ApplicationRecordSerializer
  attributes :id, :name

  has_many :groups
  has_many :segments
end
