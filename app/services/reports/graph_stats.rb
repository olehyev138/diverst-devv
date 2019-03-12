class Reports::GraphStats
  def initialize(graph, elements)
    # TODO:
    #  - move this to a formatter class, use framework for parsing es
    #  - filter out unselected series

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
        buckets = e.agg.buckets

        if buckets.count > 0
          row << e[:key]
        end

        # sub elements
        buckets.each do |ee|
          doc_count = ee.agg.buckets[0][:doc_count]
          if doc_count != 0
            row << doc_count
          end
        end

        if buckets.count > 0
          @body << row
        end
      end
    else
      elements.each do |e|
        # x & y
        doc_count = e.agg.buckets[0][:doc_count]
        if doc_count != 0
          @body << [e[:key], doc_count]
        end
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
