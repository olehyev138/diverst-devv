module Metrics
  module SegmentMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def segment_population
      graph = UsersSegment.get_graph_builder
      graph.set_enterprise_filter(field: 'segment.enterprise_id', value: enterprise_id)
      graph.formatter.title = "#{c_t(:segment).capitalize} Population"

      graph.query = graph.query.terms_agg(field: 'segment.name')
      graph.drilldown_graph(parent_field: 'segment.parent.name')

      graph.build
    end
  end
end
