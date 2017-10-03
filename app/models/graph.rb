class Graph < ActiveRecord::Base

    belongs_to :collection, polymorphic: true
    belongs_to :field
    belongs_to :aggregation, class_name: 'Field'

    delegate :title, to: :field

    validates :field,       presence: true
    validates :collection,  presence: true

    def data
        segments = collection.segments || field.container.enterprise.segments.all
        groups = collection.groups
        graph_data =
            if time_series
                field.highcharts_timeseries(segments: segments, groups: groups)
            else
                field.highcharts_stats(aggr_field: aggregation, segments: segments, groups: groups)
            end
        {
            type: field.type,
            highcharts: graph_data,
            hasAggregation: has_aggregation?,
            time_series: time_series,
            title: title
        }
    end

    def has_aggregation?
        !aggregation.nil?
    end
end
