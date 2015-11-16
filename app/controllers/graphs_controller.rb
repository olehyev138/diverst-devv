class GraphsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_metrics_dashboard, except: [:data, :show, :edit, :update, :destroy]
  before_action :set_graph, except: [:index, :new, :create]

  layout 'global_settings'

  def new
    @graph = @metrics_dashboard.graphs.new
  end

  def create
    @graph = @metrics_dashboard.graphs.new(graph_params)

    if @graph.save
      redirect_to @metrics_dashboard
    else
      render :edit
    end
  end

  def index
    @graphs = @metrics_dashboard.graphs
  end

   def update
    if @graph.update(graph_params)
      redirect_to @graph.metrics_dashboard
    else
      render :edit
    end
  end

  def destroy
    @graph.destroy
    redirect_to :back
  end

  def data
    render json: @graph.data
  end

  protected

  def set_metrics_dashboard
    @metrics_dashboard = current_admin.enterprise.metrics_dashboards.find(params[:metrics_dashboard_id])
  end

  def set_graph
    @graph = Graph.where(metrics_dashboard_id: current_admin.enterprise.metrics_dashboards.ids).find(params[:id])
  end

  def graph_params
    params
    .require(:graph)
    .permit(
      :field_id,
      :aggregation_id
    )
  end
end
