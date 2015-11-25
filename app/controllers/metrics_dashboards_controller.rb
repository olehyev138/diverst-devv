class MetricsDashboardsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_metrics_dashboard, except: [:index, :new, :create]

  layout 'global_settings'

  def new
    @metrics_dashboard = current_admin.enterprise.metrics_dashboards.new
  end

  def create
    @metrics_dashboard = current_admin.enterprise.metrics_dashboards.new(metrics_dashboard_params)

    if @metrics_dashboard.save
      redirect_to @metrics_dashboard
    else
      render :edit
    end
  end

  def index
    @dashboards = current_admin.enterprise.metrics_dashboards
    @nb_employees = current_admin.enterprise.employees.count
  end

  def update
    if @metrics_dashboard.update(metrics_dashboard_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @metrics_dashboard.destroy
    redirect_to action: :index
  end

  def data
    render json: @metrics_dashboard.data
  end

  protected

  def set_metrics_dashboard
    @metrics_dashboard = current_admin.enterprise.metrics_dashboards.find(params[:id])
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
