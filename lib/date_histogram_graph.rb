class DateHistogramGraph
  # container: ref to the container containing the fields
  def initialize(index:, field:, interval:, format: 'yyyy-MM-dd')
    @index = index
    @field = field
    @interval = interval
    @format = format
  end

  # Get the aggregate data from elasticsearch
  def query_elasticsearch
    query_hash = {
      aggs: {
        my_date_histogram: {
          date_histogram: {
            field: @field,
            interval: @interval,
            format: @format
          }
        }
      }
    }

    Elasticsearch::Model.client.search(
      index: @index,
      search_type: 'count',
      body: query_hash
    )
  end

  # Format an elasticsearch response to be easily sent to a Highcharts graph
  def elasticsearch_to_highcharts
  end
end
