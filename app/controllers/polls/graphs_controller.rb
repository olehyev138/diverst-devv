class Polls::GraphsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll, except: [:data, :show, :edit, :update, :destroy]
  before_action :set_graph, except: [:index, :new, :create]

  layout 'global_settings'

  def new
    @graph = @poll.graphs.new
  end

  def create
    @graph = @poll.graphs.new(graph_params)

    if @graph.save
      flash[:notice] = "Your graph was created"
      redirect_to @poll
    else
      flash[:alert] = "Your graph was not created. Please fix the errors"
      render :new
    end
  end

  protected

  def set_poll
    current_user ? @poll = current_user.enterprise.polls.find(params[:poll_id]) : user_not_authorized
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
