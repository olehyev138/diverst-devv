class GraphDownloadJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, graph_id, date_range, unset_series)
    user = User.find_by_id(user_id)
    graph = Graph.find_by_id(graph_id)

    return if user.nil? || graph.nil?

    csv = graph.graph_csv(date_range, unset_series)
    file = CsvFile.new(user_id: user.id, download_file_name: "graph_#{ graph.id }")

    file.download_file = StringIO.new(csv)
    file.download_file.instance_write(:content_type, 'text/csv')
    file.download_file.instance_write(:file_name, "graph_#{ graph.id }.csv")

    file.save!
  end
end
