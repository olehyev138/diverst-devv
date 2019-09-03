class Api::V1::Metrics::GraphsController < DiverstController
  def payload
    params
      .require(klass.symbol)
      .permit(
        :field_id,
        :aggregation_id,
        :metrics_dashboard_id,
      )
  end
end
