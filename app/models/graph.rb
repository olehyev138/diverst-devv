class Graph < ActiveRecord::Base
  belongs_to :enterprise, inverse_of: :graphs
  belongs_to :field
  belongs_to :aggregation, class_name: "Field"

  def data
    {
      type: field.type,
      highcharts: field.highcharts_data(aggr_field: aggregation),
      hasAggregation: !self.aggregation.nil?
    }
  end
end