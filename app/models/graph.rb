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
    #  - export csv
    #  - filter on segments

    # dashboard segments & graphs to scope by
    groups = collection.enterprise.groups.pluck(:name) - collection.groups.map(&:name)
    segments = collection.enterprise.segments.pluck(:name) - collection.segments.map(&:name)

    # date range to filter values on
    date_range = parse_date_range(input)

    graph = User.get_graph
    graph.set_enterprise_filter(field: 'enterprise_id', value: collection.enterprise.id)
    graph.formatter.type = 'custom'
    graph.formatter.filter_zeros = false        # filtering 0 values breaks stacked bar graphs

    graph.query = build_query(graph, groups, segments, date_range)
    parse_query(graph)

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

  def build_query(graph, groups, segments, date_range)
    # build query with/without sub terms agg, filtered by date range

    query = graph.get_new_query

    # Will be removed once we write custom graph tool
    # No way around it

    # define aggregation query
    if aggregation.present?
      if field.class == GroupsField
        query.terms_agg(field: 'user_groups.group.name') { |q|
          q.reverse_nested_agg { |qq|
            qq.terms_agg(field: aggregation.elasticsearch_field) { |qqq|
              qqq.date_range_agg(field: 'created_at', range: date_range)
            }
          }
        }
      elsif field.class == SegmentsField
        query.terms_agg(field: 'users_segments.segment.name') { |q|
          q.reverse_nested_agg { |qq|
            qq.terms_agg(field: aggregation.elasticsearch_field) { |qqq|
              qqq.date_range_agg(field: 'created_at', range: date_range)
            }
          }
        }
      else
        query = query.reverse_nested_agg { |q|
          q.terms_agg(field: field.elasticsearch_field) { |qq|
            qq.terms_agg(field: aggregation.elasticsearch_field) { |qqq|
              qqq.date_range_agg(field: 'created_at', range: date_range)
            }
          }
        }
      end
    else
      if field.class == GroupsField
        query.terms_agg(field: 'user_groups.group.name') { |q|
          q.reverse_nested_agg { |qq|
            qq.date_range_agg(field: 'created_at', range: date_range)
          }
        }
      elsif field.class == SegmentsField
        query.terms_agg(field: 'users_segments.segment.name') { |q|
          q.reverse_nested_agg { |qq|
            qq.date_range_agg(field: 'created_at', range: date_range)
          }
        }
      else
        query = query.reverse_nested_agg { |q|
          q.terms_agg(field: field.elasticsearch_field) { |qq|
              qq.date_range_agg(field: 'created_at', range: date_range)
            }
          }
      end
    end

    # wrap in filter query & return
    groups_segments_filter_query(graph, query,  groups, segments)
  end

  def groups_segments_filter_query(graph, query, groups, segments)
    graph.get_new_query.nested_agg(path: 'user_groups') { |q|
      q.bool_filter_agg(field: 'user_groups.group.name', value: groups, multi: true, negate: true) { |_| query }
    }
  end

  def parse_query(graph)
    elements =  graph.formatter.list_parser.parse_list(graph.search)

    if aggregation.present?
      graph.stacked_nested_terms(elements, field)
    else
      y_parser = graph.formatter.y_parser

      if field.class == GroupsField || field.class == SegmentsField
        graph.formatter.y_parser.parse_chain =  y_parser.agg { |p| p.date_range }
      else
        graph.formatter.y_parser.parse_chain = y_parser.date_range
      end

      graph.formatter.add_elements(elements)
    end
  end

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
