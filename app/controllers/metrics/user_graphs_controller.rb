class Metrics::UserGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index] # TODO: fix

  layout 'metrics'

  def users_per_group
    respond_to do |format|
      format.json {
        render json: @graph.users_per_group
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
