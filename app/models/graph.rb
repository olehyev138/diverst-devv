class Graph < ActiveRecord::Base
  belongs_to :metrics_dashboard, inverse_of: :graphs
  belongs_to :field
  belongs_to :aggregation, class_name: "Field"

  def title
    return field.title if aggregation.nil?
    "#{aggregation.title} by #{field.title}"
  end

  def data
    {
      type: field.type,
      highcharts: field.highcharts_data(aggr_field: aggregation),
      hasAggregation: !self.aggregation.nil?,
      title: self.title
    }
  end
end