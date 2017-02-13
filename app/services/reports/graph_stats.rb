class Reports::GraphStats
  def initialize(graph)
    @graph = graph
    @graph_content = @graph.field.highcharts_stats(
                      aggr_field: @graph.aggregation,
                      segments: @graph.collection.segments
                     )
  end

  def get_header
    header = []
    if @graph.has_aggregation?
      header = [@graph_content[:xAxisTitle]] + @graph_content[:series].map{ |s| s[:name] }
    else
      header = @graph_content[:series].map{ |s| s[:name] }
    end
    header
  end

  def get_body
    body = []
    if @graph.has_aggregation?
      @graph_content[:categories].each_with_index do |category, i|
        body[i] = [category] + @graph_content[:series].map{ |s| s[:data] }.flatten
      end
    else
      body = @graph_content[:series].map{ |s| s[:data] }.flatten.map(&:values)
    end
    body
  end
end
