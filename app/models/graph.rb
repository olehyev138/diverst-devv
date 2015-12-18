class Graph < ActiveRecord::Base
  belongs_to :collection, polymorphic: true
  belongs_to :field
  belongs_to :aggregation, class_name: "Field"

  def title
    field.title
  end

  def data
    target_ids = self.collection.graphs_population.ids

    {
      type: field.type,
      highcharts: field.highcharts_data(aggr_field: aggregation, target_ids: target_ids),
      hasAggregation: !self.aggregation.nil?,
      title: self.title
    }
  end

  def field
    Field.unscoped{ super }
  end

  def aggregation
    Field.unscoped{ super }
  end
end