class Graph < ActiveRecord::Base
  belongs_to :enterprise, inverse_of: :graphs
  belongs_to :field
  belongs_to :aggregation, class_name: "Field"

  def elastic_data
    field.elastic_stats(aggr_field: aggregation)
  end

  def data
    {
      type: field.type,
      elastic_data: elastic_data,
      hasAggregation: !self.aggregation.nil?
    }
  end
end