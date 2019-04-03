module Metrics
  module GroupMetrics
    extend ActiveSupport::Concern
    include MetricsUtil

    def group_population(date_range, scoped_groups)
      date_range = parse_date_range(date_range)

      graph = UserGroup.get_graph_builder
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)
      graph.formatter.title = "#{Enterprise.find(self.enterprise_id).custom_text.erg.capitalize} Population"

      graph.query = graph.query.terms_agg(field: 'group.name') { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      if scoped_groups.present?
        graph.query = add_scoped_model_filter(graph, 'group_id', scoped_groups)
      end

      graph.formatter.parser.extractors[:y] = graph.formatter.parser.date_range(key: :doc_count)

      graph.drilldown_graph(parent_field: 'group.parent.name')

      graph.build
    end
  end
end
