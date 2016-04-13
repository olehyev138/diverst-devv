class GraphsController < ApplicationController
  before_action :set_collection, except: [:data, :show, :edit, :update, :destroy]
  before_action :set_graph, except: [:index, :new, :create]

  layout 'dashboard'

  def new
    @graph = @collection.graphs.new
    @graph.range_from = 1.year.ago
  end

  def create
    @graph = @collection.graphs.new(graph_params)

    if @graph.save
      redirect_to @collection
    else
      render :edit
    end
  end

  def index
    @graphs = @collection.graphs
  end

  def update
    if @graph.update(graph_params)
      redirect_to @graph.collection
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

  def group_population
    GroupPopulationGraph.data
  end

  protected

  def set_collection
    if params[:metrics_dashboard_id]
      @collection = current_user.enterprise.metrics_dashboards.find(params[:metrics_dashboard_id])
    elsif params[:poll_id]
      @collection = current_user.enterprise.polls.find(params[:poll_id])
    end
  end

  def set_graph
    @graph = Graph.find(params[:id])
  end

  def graph_params
    params
      .require(:graph)
      .permit(
        :field_id,
        :aggregation_id,
        :time_series,
        :range_from,
        :range_to
      )
  end
end
