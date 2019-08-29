class Api::V1::MetricsDashboardsController < DiverstController
  def payload
    params
      .require(klass.symbol)
      .permit(
        :enterprise_id,
        :name,
        :owner_id,
        :shareable_token,
        group_ids: [],
        segment_ids: []
    )
  end
end
