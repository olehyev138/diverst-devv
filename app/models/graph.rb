class Graph < ActiveRecord::Base
  belongs_to :collection, polymorphic: true
  belongs_to :field
  belongs_to :aggregation, class_name: 'Field'

  delegate :title, to: :field

  def data
    {
      type: field.type,
      highcharts: field.highcharts_data(aggr_field: aggregation, segments: collection.segments),
      hasAggregation: !aggregation.nil?,
      title: title
    }
  end
end
