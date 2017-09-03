class GraphsController < ApplicationController
  before_action :set_collection, except: [:data, :update]
  before_action :set_graph, except: [:index, :new, :create]

  layout 'dashboard'

  def new
    @graph = @collection.graphs.new
    @graph.range_from = 1.year.ago
  end
  
  def create
    @graph = @collection.graphs.new(graph_params)

    if @graph.save
      flash[:notice] = "Your graph was created"
      redirect_to @collection
    else
      flash[:alert] = "Your graph was not created. Please fix the errors"
      render :new
    end
  end

  # missing a template
  def index
    @graphs = @collection.graphs
  end

  def update
    if @graph.update(graph_params)
      flash[:notice] = "Your graph was updated"
      redirect_to @graph.collection
    else
      flash[:alert] = "Your graph was not updated. Please fix the errors"
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

  def export_csv
    strategy = @graph.time_series ? Reports::GraphTimeseries.new(@graph) : Reports::GraphStats.new(@graph)
    report = Reports::Generator.new(strategy)
    send_data report.to_csv, filename: "graph_#{ @graph.id }.csv"
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
