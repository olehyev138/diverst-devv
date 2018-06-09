module GraphsHelper
  def aggregation_text(graph)
    text = 'Aggregated by '
    text << graph.aggregation.title.downcase.to_s if graph.collection_type == 'MetricsDashboard'
    text << "answer to \"#{graph.aggregation.title}\"" if graph.collection_type == 'Poll'
    text
  end
end
