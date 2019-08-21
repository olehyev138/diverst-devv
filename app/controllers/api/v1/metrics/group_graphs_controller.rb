class Api::V1::Metrics::GroupGraphsController < DiverstController
  include Metrics

  def group_population
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.group_population(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsGroupPopulationDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_group_population)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end
end
