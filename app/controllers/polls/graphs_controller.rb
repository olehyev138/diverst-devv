class Polls::GraphsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_poll, except: [:data, :show, :edit, :update, :destroy]
  before_action :set_graph, except: [:index, :new, :create]

  layout 'global_settings'

  def new
    @graph = @poll.graphs.new
  end

  def create
    @graph = @poll.graphs.new(graph_params)

    if @graph.save
      redirect_to @poll
    else
      render :edit
    end
  end

  def index
    @graphs = @poll.graphs
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

  protected

  def set_poll
    @poll = current_admin.enterprise.polls.find(params[:poll_id])
  end

  def set_graph
    @graph = current_admin.enterprise.poll_graphs.find(params[:id])
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
