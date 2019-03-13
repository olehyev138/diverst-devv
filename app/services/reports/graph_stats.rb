class Reports::GraphStats
  def initialize(graph, elements, date_range, unset_series)
    @agg_list_parser = BaseGraph::ElasticsearchParser.new
    @agg_list_parser.parse_chain = @agg_list_parser.nested_terms_list

    @x_parser = BaseGraph::ElasticsearchParser.new

    @y_parser = BaseGraph::ElasticsearchParser.new(key: :doc_count)
    @y_parser.parse_chain = @y_parser.date_range

    @graph = graph
    @elements = elements
    @date_range = date_range
    @unset_series = unset_series
  end

  def get_header
    header = []
    header << [@graph.title]
    header << ['From' + @date_range[:from], 'To:' + @date_range[:to]]

    # If aggregation, add each aggregation field value as a column
    header_row = [@graph.field.title]
    if @graph.aggregation.present?
      @agg_list_parser.parse_list(@elements[0]).each do |ee|
        next if @unset_series.include? ee[:key] # skip series/aggregation values that are unset in UI
        header_row << ee[:key]
      end
    end

    header_row << 'Y'
    header << header_row

    header
  end

  def get_body
    body = []

    if @graph.aggregation.present?
      @elements.each do |e|
        row = []
        buckets = @agg_list_parser.parse_list(e)
        next if buckets.count <= 0

        row << e[:key]

        # sub elements
        buckets.each do |ee|
          key = @x_parser.parse(ee)
          doc_count = @y_parser.parse(ee)

          if doc_count != 0 && @unset_series.exclude?(key)
            row << doc_count
          end
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
end
