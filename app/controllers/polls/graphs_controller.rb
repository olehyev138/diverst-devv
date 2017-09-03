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

  def index
    @graphs = @poll.graphs
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

  protected

  def set_poll
    @poll = current_user.enterprise.polls.find(params[:poll_id])
  end

  def set_graph
    @graph = current_user.enterprise.poll_graphs.find(params[:id])
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
