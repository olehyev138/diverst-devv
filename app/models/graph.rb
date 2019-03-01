class Graph < BaseClass

  belongs_to :poll
  belongs_to :metrics_dashboard
  belongs_to :field
  belongs_to :aggregation, class_name: 'Field'

  delegate :title, to: :field

  validates :field,       presence: true

  def data(input)
    # Currently this is somewhat hacked together
    # This will all be written properly once custom graphs are rewritten

    # TODO:
    #  - export CSV
    #  - filter on dashboard groups

    segments = collection.segments || field.container.enterprise.segments.all
    groups = collection.enterprise.groups.pluck(:name) - collection.groups.map(&:name)

    graph = User.get_graph

    graph.set_enterprise_filter(field: 'enterprise_id', value: collection.enterprise.id)
    graph.formatter.type = 'custom'

    date_range = parse_date_range(input)

    # build query with or without sub aggregation
    if aggregation.present?
      graph.query = graph.query.terms_agg(field: field.elasticsearch_field) { |q|
        q.terms_agg(field: aggregation.elasticsearch_field) { |qq|
          qq.date_range_agg(field: 'created_at', range: date_range)
        }
      }
    else
      graph.query = graph.query.terms_agg(field: field.elasticsearch_field) { |q|
        q.date_range_agg(field: 'created_at', range: date_range)
      }
    end

    elements =  graph.formatter.list_parser.parse_list(graph.search)

    if aggregation.present?
      graph.stacked_nested_terms(elements)
    else
      graph.formatter.y_parser.parse_chain = graph.formatter.y_parser.date_range
      graph.formatter.add_elements(elements)
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

  private

  def parse_date_range(date_range)
    # Parse a date range from a frontend range_controller for a es date range aggregation
    # Date range is {} or looks like { from: <>, to: <> }, with to being optional

    default_from_date = 'now-200y/y'
    default_to_date = DateTime.tomorrow.strftime('%F')

    return { from: default_from_date, to: default_to_date } if date_range.blank?

    from_date = date_range[:from_date].presence || default_from_date
    to_date = DateTime.parse((date_range[:to_date].presence || default_to_date)).strftime('%F')

    from_date = case from_date
                when '1m'     then 'now-1M/M'
                when '3m'     then 'now-3M/M'
                when '6m'     then 'now-3M/M'
                when 'ytd'    then Time.now.beginning_of_year.strftime('%F')
                when '1y'     then 'now-1y/y'
                when 'all'    then 'now-200y/y'
                else
                  DateTime.parse(from_date).strftime('%F')
                end

    { from: from_date, to: to_date }
  end
end
