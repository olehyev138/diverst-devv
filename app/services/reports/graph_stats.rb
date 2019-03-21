class Reports::GraphStats
  def initialize(graph, elements, date_range, date_range_str, unset_series)
    @agg_list_parser = BaseGraph::ElasticsearchParser.new
    @agg_list_parser.parse_chain = @agg_list_parser.nested_terms_list

    @x_parser = BaseGraph::ElasticsearchParser.new

    @y_parser = BaseGraph::ElasticsearchParser.new(key: :doc_count)
    @y_parser.parse_chain = @y_parser.date_range

    @graph = graph
    @elements = elements
    @date_range = date_range
    @ui_date_range = ui_parse_date_range(date_range_str)
    @unset_series = unset_series
  end

  def get_header
    header = []
    header << [@graph.title]
    header << ['From' + @ui_date_range[:from], 'To:' + @ui_date_range[:to]]

    # If aggregation, add each aggregation field value as a column
    header_row = [@graph.field.title]
    if @graph.aggregation.present?
      sub_elements = @agg_list_parser.parse_list(@elements[0]).sort_by { |ee| ee[:key] }
      sub_elements.each do |ee|
        next if @unset_series.include? ee[:key] # skip series/aggregation values that are unset in UI
        header_row << ee[:key]
      end
    end

    header << header_row

    header
  end

  def get_body
    body = []

    if @graph.aggregation.present?
      @elements.each do |e|
        row = []
        buckets = @agg_list_parser.parse_list(e).sort_by { |ee| ee[:key] }

        next if buckets.count == 0

        row << @x_parser.parse(e)

        # sub elements
        buckets.each do |ee|
          key = @x_parser.parse(ee)
          doc_count = @y_parser.parse(ee)

          next if @unset_series.include?(key)
          row << doc_count
        end

        body << row
      end
    else
      @elements.each do |e|
        key = @x_parser.parse(e)
        doc_count = @y_parser.parse(e)

        next if doc_count == 0
        body << [key, doc_count]
      end
    end

    body
  end

  def ui_parse_date_range(date_range)
    # Parse a date range from a frontend range_controller for a es date range aggregation
    # Date range is {} or looks like { from: <>, to: <> }, with to being optional

    default_from_date = 'All'
    default_to_date = DateTime.tomorrow.strftime('%F')

    return { from: default_from_date, to: default_to_date } if date_range.blank?

    from_date = date_range[:from_date].presence || default_from_date
    to_date = DateTime.parse((date_range[:to_date].presence || default_to_date)).strftime('%F')

    from_date = case from_date
                when '1m'     then 1.month.ago.strftime('%F')
                when '3m'     then 3.months.ago.strftime('%F')
                when '6m'     then 6.months.ago.strftime('%F')
                when 'ytd'    then Time.now.beginning_of_year.strftime('%F')
                when '1y'     then 1.year.ago.strftime('%F')
                when 'all'    then 'All'
                else
                  DateTime.parse(from_date).strftime('%F')
                end

    { from: from_date, to: to_date }
  end
end
