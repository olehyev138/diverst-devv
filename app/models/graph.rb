class Graph < ActiveRecord::Base
  belongs_to :collection, polymorphic: true
  belongs_to :field
  belongs_to :aggregation, class_name: 'Field'

  delegate :title, to: :field

  def data
    {
      type: field.type,
      highcharts: time_series ? field.highcharts_timeseries(segments: collection.segments) : field.highcharts_stats(aggr_field: aggregation, segments: collection.segments),
      hasAggregation: has_aggregation?,
      time_series: time_series,
      title: title
    }
  end

  def has_aggregation?
    !aggregation.nil?
  end
end
