class GraphSerializer < ApplicationRecordSerializer
  attributes :id, :metrics_dashboard_id, :permissions

  belongs_to :field
  belongs_to :aggregation
end
