module Metrics
  module UserMetrics
    extend ActiveSupport::Concern
    include Util

    def users_per_group()
      graph = UserGroup.get_graph
      graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)
      graph.formatter.type = 'pie'
      graph.formatter.title = "User population per group"

      graph.query = graph.query.terms_agg(field: 'group.name')
      graph.drilldown_graph(parent_field: 'group.parent.name')

      graph.build
    end

    def user_growth(date_range_str)
      date_range = parse_date_range(date_range_str)

      graph = User.get_graph
      graph.set_enterprise_filter(value: enterprise_id)
      graph.formatter.type = 'line'
      graph.formatter.title = 'Growth of employees'

      graph.query = graph.query.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc') { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }

      parser = graph.formatter.parser
      custom_parser = graph.get_new_parser
      parser.extractors[:y] = -> (_, args) { args[:total] }
      custom_parser.extractors[:count] = custom_parser.date_range(key: :doc_count)

      total = 0
      elements = graph.search
      graph.formatter.add_series

      elements.each { |e|
        total += custom_parser.parse(e)[:count]
        graph.formatter.add_element(e, total: total)
      }

      graph.build
    end
  end
end
