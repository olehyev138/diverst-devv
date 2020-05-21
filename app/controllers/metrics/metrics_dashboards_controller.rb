class Metrics::MetricsDashboardsController < ApplicationController
  before_action :authenticate_user!, except: [:shared_dashboard]
  after_action :verify_authorized, except: [:shared_dashboard]
  before_action :set_metrics_dashboard, except: [:index, :new, :create, :shared_dashboard]
  after_action :add_shared_dashboards, only: [:create, :update]
  after_action :remove_shared_dashboards, only: [:update]
  after_action :visit_page, only: [:index, :new, :show, :edit]

  layout 'metrics'

  def index
    authorize MetricsDashboard
    @dashboards = policy_scope(MetricsDashboard).includes(:enterprise, :segments)
  end

  def new
    authorize MetricsDashboard
    @metrics_dashboard = current_user.enterprise.metrics_dashboards.new
  end

  def create
    authorize MetricsDashboard
    @metrics_dashboard = current_user.enterprise.metrics_dashboards.new(metrics_dashboard_params.except(:shared_user_ids))
    @metrics_dashboard.owner = current_user


    if @metrics_dashboard.save
      track_activity(@metrics_dashboard, :create)
      flash[:notice] = 'Your dashboard was created'
      redirect_to new_metrics_metrics_dashboard_graph_path(@metrics_dashboard)
    else
      flash[:alert] = 'Your dashboard was not created. Please fix the errors'
      render :new
    end
  end

  def show
    authorize @metrics_dashboard
    @graphs = @metrics_dashboard.graphs.includes(:field, :aggregation)

    unless @metrics_dashboard.update_shareable_token
      render :edit
    end
  end

  def shared_dashboard
    if params[:token]
      @metrics_dashboard = MetricsDashboard.find_by_shareable_token(params[:token])
    end

    not_found! if @metrics_dashboard.nil?

    @graphs = @metrics_dashboard.graphs.includes(:field, :aggregation)

    render layout: 'guest'
  end

  def edit
    authorize @metrics_dashboard
  end

  def update
    authorize @metrics_dashboard

    if @metrics_dashboard.update(metrics_dashboard_params.except(:shared_user_ids))
      track_activity(@metrics_dashboard, :update)
      flash[:notice] = 'Your dashboard was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your dashboard was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    if @metrics_dashboard.is_user_shared?(current_user)
      authorize @metrics_dashboard, :index?

      @metrics_dashboard.shared_metrics_dashboards.destroy(SharedMetricsDashboard.find_by(user_id: current_user.id))
      redirect_to action: :index
    else
      authorize @metrics_dashboard

      track_activity(@metrics_dashboard, :destroy)
      @metrics_dashboard.destroy
      redirect_to action: :index
    end
  end

  # no route for this action
  def data
    render json: @metrics_dashboard.data
  end

  protected

  def add_shared_dashboards
    return unless metrics_dashboard_params[:shared_user_ids] && @metrics_dashboard.valid?

    metrics_dashboard_params[:shared_user_ids].each do |user_id|
      user = User.find_by_id(user_id)

      # Only add association if user exists and belongs to the same enterprise
      next if (!user) || (user.enterprise != @metrics_dashboard.enterprise)
      next if SharedMetricsDashboard.where(user_id: user_id, metrics_dashboard_id: @metrics_dashboard.id).exists?

      SharedMetricsDashboard.create!(metrics_dashboard_id: @metrics_dashboard.id, user_id: user.id)
    end
  end

  def remove_shared_dashboards
    return unless @metrics_dashboard.valid?

    unless metrics_dashboard_params[:shared_user_ids]
      @metrics_dashboard.shared_metrics_dashboards.destroy_all
      return
    end

    @metrics_dashboard.shared_metrics_dashboards.each do |shared_dashboard|
      if metrics_dashboard_params[:shared_user_ids].exclude?(shared_dashboard.user_id)
        @metrics_dashboard.shared_metrics_dashboards.destroy(shared_dashboard)
      end
    end
  end

  def set_metrics_dashboard
    @metrics_dashboard = current_user.enterprise.metrics_dashboards.find(params[:id])
  end

  def metrics_dashboard_params
    params
      .require(:metrics_dashboard)
      .permit(
        :name,
        segment_ids: [],
        group_ids: [],
        shared_user_ids: []
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Metrics Dashboards'
    when 'new'
      'Metrics Dashboard Creation'
    when 'show'
      'Metrics Dashboard View'
    when 'edit'
      'Metrics Dashboard Edit'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
