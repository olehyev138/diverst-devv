class Metrics::GroupGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index]

  layout 'metrics'

  def group_population
    respond_to do |format|
      format.json {
        render json: @graph.group_population(params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def group_params
    params.permit(
      :date_range,
      scoped_by_models: []
    )
  end
end
