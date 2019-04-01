class Metrics::OverviewGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index] # TODO: fix

  layout 'metrics'

  def index
    authorize MetricsDashboard

    @dashboards = policy_scope(MetricsDashboard).includes(:enterprise, :segments)

    enterprise = current_user.enterprise
    @general_metrics = {
      nb_users: enterprise.users.active.count,
      nb_ergs: enterprise.groups.count,
      nb_segments: enterprise.segments.count,
      nb_resources: enterprise.resources_count,
      nb_polls: enterprise.polls.count,
      nb_ongoing_campaigns: enterprise.campaigns.ongoing.count,
      average_nb_members_per_group: Group.avg_members_per_group(enterprise: enterprise)
    }
  end

  def user_growth
    respond_to do |format|
      format.json {
        render json: @graph.user_growth(params[:input])
      }
    end
  end

  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def overview_params
    params.permit(
      :input
    )
  end
end
