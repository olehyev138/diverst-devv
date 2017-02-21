class MetricsDashboardsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_metrics_dashboard, except: [:index, :new, :create]

  layout 'erg_manager'

  def new
    authorize MetricsDashboard
    @metrics_dashboard = current_user.enterprise.metrics_dashboards.new
  end

  def create
    authorize MetricsDashboard
    @metrics_dashboard = current_user.enterprise.metrics_dashboards.new(metrics_dashboard_params)
    @metrics_dashboard.owner = current_user

    if @metrics_dashboard.save
      track_activity(@metrics_dashboard, :create)
      redirect_to @metrics_dashboard
    else
      render :new
    end
  end

  def index
    authorize MetricsDashboard

    @dashboards = policy_scope(MetricsDashboard).includes(:enterprise, :segments)

    enterprise = current_user.enterprise
    @general_metrics = {
      nb_users: enterprise.users.count,
      nb_ergs: enterprise.groups.count,
      nb_segments: enterprise.segments.count,
      nb_resources: enterprise.resources.count,
      nb_polls: enterprise.polls.count,
      nb_ongoing_campaigns: enterprise.campaigns.ongoing.count,
      average_nb_members_per_group: Group.avg_members_per_group(enterprise: enterprise)
    }
  end

  def show
    authorize @metrics_dashboard

    @graphs = @metrics_dashboard.graphs.includes(:field, :aggregation)
  end

  def edit
    authorize @metrics_dashboard
  end

  def update
    authorize @metrics_dashboard

    if @metrics_dashboard.update(metrics_dashboard_params)
      track_activity(@metrics_dashboard, :update)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    authorize @metrics_dashboard

    @metrics_dashboard.destroy
    redirect_to action: :index
  end

  def data
    render json: @metrics_dashboard.data
  end

  protected

  def set_metrics_dashboard
    @metrics_dashboard = current_user.enterprise.metrics_dashboards.find(params[:id])
  end

  def metrics_dashboard_params
    params
      .require(:metrics_dashboard)
      .permit(
        :name,
        segment_ids: []
      )
  end
end
