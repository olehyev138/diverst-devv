class Reports::GraphStats
  def initialize(graph)
    @graph = graph
    @graph_content = @graph.field.highcharts_stats(
                      aggr_field: @graph.aggregation,
                      segments: @graph.collection.segments
                     )
  end

  def get_header
    header = @graph_content[:series].map{ |s| s[:name] }
    header.unshift(@graph_content[:xAxisTitle]) if @graph.has_aggregation?
    header
  end

  def get_body
    body = []
    if @graph.has_aggregation? || @graph.field.numeric?
      @graph_content[:categories].each_with_index do |category, i|
        body[i] = [category] + @graph_content[:series].map{ |s| s[:data][i] }
      end
    else
      body = @graph_content[:series].map{ |s| s[:data] }.flatten.map(&:values)
    end
    body
  end
end
