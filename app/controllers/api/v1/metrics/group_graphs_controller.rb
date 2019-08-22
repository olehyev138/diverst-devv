class Api::V1::Metrics::GroupGraphsController < DiverstController
  include Api::V1::Concerns::Metrics

  def group_population
    authorize MetricsDashboard, :index?

    render json: @graph.group_population(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end
end
