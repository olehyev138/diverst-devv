class Metrics::UserGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    @user_metrics = {
      total_active_users: current_user.enterprise.users.active.count,
      user_growth: @graph.user_change_percentage,
      group_memberships: @graph.group_memberships
    }
  end

  def users_per_group
    respond_to do |format|
      format.json {
        render json: @graph.users_per_group
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
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def users_per_segment
    respond_to do |format|
      format.json {
        render json: @graph.users_per_segment
      }
      format.csv {
        GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_segment_population)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end


  def user_growth
    respond_to do |format|
      format.json {
        render json: @graph.user_growth(metrics_params[:date_range])
      }
    end
  end
end
