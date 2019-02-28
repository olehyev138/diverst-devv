class Graph < BaseClass

    belongs_to :poll
    belongs_to :metrics_dashboard
    belongs_to :field
    belongs_to :aggregation, class_name: 'Field'

    delegate :title, to: :field

    validates :field,       presence: true

    def data
        segments = collection.segments || field.container.enterprise.segments.all
        groups = collection.groups

        # TODO: export CSV

        graph = User.get_graph

        # TODO:  get enterprise value
        graph.set_enterprise_filter(field: 'enterprise_id', value: 1)

        # TODO:
        #  - filter on dashboard groups
        #  - filter on date range
        graph.query = graph.query.terms_agg(field: field.elasticsearch_field) { |q|
          q.terms_agg(field: aggregation.elasticsearch_field) }

        # Nvd3 requires stacked bar data in a slightly irregular format
        # This will all be dealt with properly once we properly redo custom graphs

        elements =  graph.formatter.list_parser.parse_list(graph.search)

        elements.each do |element|
          if element.agg.present?
            key = element[:key]
            series_index = -1

            element.agg.buckets.each do |sub_element|
              series_name = sub_element[:key]
              series_index += 1

              graph.formatter.add_element({ key: key, doc_count: sub_element[:doc_count] }, series_index: series_index)
            end
          else
            graph.formatter.add_element(element)
          end
        end

        return graph.build
    end

    def collection
        return metrics_dashboard if metrics_dashboard.present?
        return poll
    end

    def has_aggregation?
        !aggregation.nil?
    end

    def graph_csv
      strategy = self.time_series ? Reports::GraphTimeseries.new(self) : Reports::GraphStats.new(self)
      report = Reports::Generator.new(strategy)

      report.to_csv
    end
end
