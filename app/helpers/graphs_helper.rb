module GraphsHelper
  def aggregation_text(graph)
    text = 'Aggregated by '
    text << graph.aggregation.title.downcase.to_s if graph.metrics_dashboard
    text << "answer to \"#{graph.aggregation.title}\"" if graph.poll
    text
  end
end
