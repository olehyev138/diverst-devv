class Graph < BaseClass

  belongs_to :poll
  belongs_to :metrics_dashboard
  belongs_to :field
  belongs_to :aggregation, class_name: 'Field'

  delegate :title, to: :field

  validates :field,       presence: true

  after_initialize :set_graph_builder
  after_initialize :set_groups_segments

  def set_graph_builder
    if @graph_builder.blank? && collection.present?
      @graph_builder = get_custom_class.get_graph
      @graph_builder.set_enterprise_filter(field: 'user.enterprise_id', value: collection.enterprise.id)

      @graph_builder.formatter.type = 'custom'
      @graph_builder.formatter.filter_zeros = false        # filtering 0 values breaks stacked bar graphs
    end
  end

  def set_groups_segments
    # dashboard groups & segments to scope by
    # we get all groups & segments that we do *not* want and then filter them out
    if (@groups.blank? || @segments.blank?) && collection.present?
      @groups = collection.enterprise.groups.pluck(:name) - collection.groups.map(&:name)
      @segments = collection.enterprise.segments.pluck(:name) - collection.segments.map(&:name)
    end
  end

  def data(date_range_str)
    # date range to filter values on
    date_range = parse_date_range(date_range_str)
    build_query(date_range)
    parse_query

    return @graph_builder.build
  end

  def collection
    return metrics_dashboard if metrics_dashboard.present?
    return poll
  end

  def has_aggregation?
    !aggregation.nil?
  end

  def graph_csv(date_range_str, unset_series)
    date_range = parse_date_range(date_range_str)
    build_query(date_range)

    strategy = Reports::GraphStats.new(self, @graph_builder.search, date_range_str, unset_series)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  private

  def build_query(date_range)
    # If aggregation field is present we use an additional nested terms query
    # Lastly we filter on date for the User model.
    query = @graph_builder.get_new_query

    if aggregation.present?
      query.terms_agg(field: field.elasticsearch_field, min_doc_count: 0) { |q|
        q.terms_agg(field: aggregation.elasticsearch_field, min_doc_count: 0) { |qq|
          qq.date_range_agg(field: 'user.created_at', range: date_range)
        }
      }
    else
      query.terms_agg(field: field.elasticsearch_field, min_doc_count: 1) { |q|
        q.date_range_agg(field: 'user.created_at', range: date_range)
      }
    end

    # wrap query in filter on groups & segments that we do *not* want included
    query = @graph_builder.get_new_query.bool_filter_agg { |_| query }
    query.add_filter_clause(field: 'group.name', value: @groups, bool_op: :must_not, multi: true)
    query.add_filter_clause(field: 'segment.name', value: @segments, bool_op: :must_not, multi: true)

    @graph_builder.query = query
  end

  def parse_query
    # Parse response
    @graph_builder.formatter.type = 'custom'
    parser = @graph_builder.formatter.parser

    elements = parser.get_elements(@graph_builder.search)

    if aggregation.present?
      # Nvd3 requires an irregular data format for nested term aggregations, use a helper to format it
      @graph_builder.stacked_nested_terms(elements)
    else
      #@graph_builder.formatter.y_parser.parse_chain = @graph_builder.formatter.y_parser.date_range
      parser.extractors[:y] = parser.date_range(key: :doc_count)
      @graph_builder.formatter.add_elements(elements)
    end

    @graph_builder
  end

  def get_custom_class
    # Define a 'Custom Class' to use for searching
    # Bit of a hacky work around, but still light years better then the previous version
    # We search *both* UserGroup and UsersSegment indices.
    #  - we do this so that we can filter by group & segment
    #  - we must use these bridge classes as opposed to User because User does not have a
    #    singular relationship with a group/segment
    Class.new do
      include BaseGraph
      include BaseSearch
      def self.__elasticsearch__
        Class.new do
          def self.search(query)
            Elasticsearch::Model.search(query, [UserGroup, UsersSegment])
          end
        end
      end
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
                when '6m'     then 'now-6M/M'
                when 'ytd'    then Time.now.beginning_of_year.strftime('%F')
                when '1y'     then 'now-1y/y'
                when 'all'    then 'now-200y/y'
                else
                  DateTime.parse(from_date).strftime('%F')
                end

    { from: from_date, to: to_date }
  end
end
