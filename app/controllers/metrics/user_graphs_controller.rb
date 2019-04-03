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

  def user_growth
    respond_to do |format|
      format.json {
        render json: @graph.user_growth(user_params[:date_range])
      }
    end
  end

  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def user_params
    params.permit(
      date_range: [
        :from_date,
        :to_date
      ],
      scoped_by_models: []
    )
  end
end
