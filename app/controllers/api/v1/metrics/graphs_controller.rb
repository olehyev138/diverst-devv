class Api::V1::Metrics::GraphsController < DiverstController
  include Api::V1::Concerns::Metrics

  def data
    graph = Graph.find_by(id: payload[:id])

    render json: {} unless graph
    render json: graph.data(payload[:date_range])
  end

  def payload
    params
      .require(klass.symbol)
      .permit(
        :id,
        :field_id,
        :aggregation_id,
        :metrics_dashboard_id,
      )
  end
end
