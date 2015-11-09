class GraphsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_graph, except: []

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
