class GraphSerializer < ApplicationRecordSerializer
  attributes :id, :metrics_dashboard_id

  belongs_to :field
  belongs_to :aggregation
end
