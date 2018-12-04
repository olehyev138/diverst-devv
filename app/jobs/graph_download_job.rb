class GraphDownloadJob < ActiveJob::Base
    queue_as :default

    def perform(user_id, graph_id)
        user = User.find_by_id(user_id)
        return if user.nil?

        graph = Graph.find_by_id(graph_id)
        return if graph.nil?

        csv = graph.graph_csv
        file = CsvFile.new(user_id: user.id, download_file_name: "graph_#{ graph.id }")

        file.download_file = StringIO.new(csv)
        file.download_file.instance_write(:content_type, 'text/csv')
        file.download_file.instance_write(:file_name, "graph_#{ graph.id }.csv")

        file.save!
    end
end
