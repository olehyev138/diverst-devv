class Api::V1::Metrics::UserGraphsController < DiverstController
  include Api::V1::Concerns::Metrics

  def user_growth
    authorize MetricsDashboard, :index?

    render json: @graph.user_growth(metrics_params[:date_range])
  end
end
