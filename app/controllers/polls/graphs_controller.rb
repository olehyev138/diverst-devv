class Polls::GraphsController < ApplicationController
  before_action :set_poll
  
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
    @poll = current_user.enterprise.polls.find(params[:poll_id])
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
