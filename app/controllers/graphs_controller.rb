class GraphsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_graph, except: [:index, :new, :create]

  layout 'global_settings'

  def new
    @graph = current_admin.enterprise.graphs.new
  end

  def create
    @graph = current_admin.enterprise.graphs.new(graph_params)

    if @graph.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def index
    @graphs = current_admin.enterprise.graphs
  end

   def update
    if @graph.update(graph_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @graph.destroy
    redirect_to action: :index
  end

  def data
    render json: @graph.data
  end

  protected

  def set_graph
    @graph = current_admin.enterprise.graphs.find(params[:id])
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
