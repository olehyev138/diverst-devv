class Reports::GraphStats
  def initialize(graph, graph_builder)
    # Functional raw version of csv export

    # TODO:
    #  - move this to a formatter class, use frmaework for parsing es
    #  - filter out zero values
    #  - filter out unselected series

    elements =  graph_builder.formatter.list_parser.parse_list(graph_builder.search)

    # columns are - x label, y0 .. yn lables, total
    @header = [graph.field.title]
    if graph.aggregation.present?
      elements[0].agg.buckets.each do |ee|
          @header << ee[:key]
      end
    end

    @header << 'Y'
    @body = []

    if graph.aggregation.present?
      # x & y0, y1, yn, y_total
      elements.each do |e|
        row = []
        row << e[:key]

        # sub elements
        e.agg.buckets.each do |ee|
          row << ee.agg.buckets[0][:doc_count]
        end

        @body << row
      end
    else
      elements.each do |e|
        # x & y
        @body << [e[:key], e.agg.buckets[0][:doc_count]]
      end
    end
  end

  def get_header
    @header
  end

  def get_body
    @body
  end
end
