class Polls::GraphsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll, except: [:data, :show, :edit, :update, :destroy]
  before_action :set_graph, except: [:index, :new, :create]
  after_action :visit_page, only: [:new]

  layout 'global_settings'

  def new
    @graph = @poll.graphs.new
  end

  def create
    @graph = @poll.graphs.new(graph_params)

    if @graph.save
      flash[:notice] = 'Your graph was created'
      redirect_to @poll
    else
      flash[:alert] = 'Your graph was not created. Please fix the errors'
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'new'
      'Poll Graph Creation'
    else
      "#{controller_name}##{action_name}"
    end
  rescue
    "#{controller_name}##{action_name}"
  end
end
