class Reports::GraphTimeseries
  def initialize(graph)
    @graph = graph
    @graph_content = @graph.field
                           .highcharts_timeseries(segments: @graph.collection.segments, groups: @graph.collection.groups)
  end

  def get_header
    @graph_content.map { |s| s[:name] }.unshift('')
  end

  def get_body
    body = []
    column_length = @graph_content.length
    grouped_dates.each do |date, infos|
      columns = Array.new(column_length, 0)
      infos.each { |info| columns[info.keys.first] = info.values.first }
      body << [date] + columns
    end
    body
  end

  private

  def grouped_dates
    dates_info = {}
    @graph_content.each_with_index do |content, i|
      content[:data].each do |date_info|
        dates_info[to_date(date_info.first)] = [] unless dates_info[date_info.first]
        dates_info[to_date(date_info.first)] << { i => date_info.second }
      end
    end
    dates_info
  end

  def to_date(miliseconds)
    DateTime.strptime((miliseconds / 1000).to_s, '%s')
  end
end
