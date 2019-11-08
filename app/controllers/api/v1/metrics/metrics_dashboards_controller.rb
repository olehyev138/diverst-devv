class Api::V1::Metrics::MetricsDashboardsController < DiverstController
  def payload
    params
      .require(klass.symbol)
      .permit(
        :name,
        :owner_id,
        :shareable_token,
        group_ids: [],
        segment_ids: []
      )
  end
end
