class Metrics::UserGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    authorize MetricsDashboard

    @user_metrics = {
      total_active_users: current_user.enterprise.users.active.count,
      user_growth: @graph.user_change_percentage,
      group_memberships: @graph.group_memberships
    }

    respond_to do |format|
      format.html
    end
  end

  def user_groups_intersection
    @users = current_user.enterprise.users
    @users = @graph.user_groups_intersection(metrics_params[:scoped_by_models]) if metrics_params[:scoped_by_models].present?

    respond_to do |format|
      format.json { render json: UserDatatable.new(view_context, @users, read_only: true) }
      format.csv {
        MetricsUserGroupsIntersectionDownloadJob.perform_later(current_user.id, @users.to_a)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def users_per_group
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.group_population(metrics_params[:date_range], nil)
      }
      format.csv {
        GenericGraphsGroupPopulationDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          @from_date,
          @to_date
        )
        track_activity(current_user.enterprise, :export_generic_graphs_group_population)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def users_per_segment
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.segment_population
      }
      format.csv {
        GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_segment_population)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def user_growth
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.user_growth(metrics_params[:date_range])
      }
    end
  end
end
