class Graph < ActiveRecord::Base
  belongs_to :collection, polymorphic: true
  belongs_to :field
  belongs_to :aggregation, class_name: "Field"

  def title
    return field.title if aggregation.nil?
    "#{aggregation.title} by #{field.title}"
  end

  def data
    {
      type: field.type,
      highcharts: field.highcharts_data(aggr_field: aggregation, target_segment_ids: self.collection.segments.ids),
      hasAggregation: !self.aggregation.nil?,
      title: self.title
    }
  end
end