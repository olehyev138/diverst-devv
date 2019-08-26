class Metrics::GraphsController < ApplicationController
  before_action :authenticate_user!, except: [:data, :export_csv] # TODO vulnerability - check current_user or enterprise token to be present
  before_action :set_graph, except: [:index, :new, :create]
  before_action :set_collection, except: [:data, :export_csv]
  after_action :visit_page, only: [:new, :edit, :index]

  layout 'dashboard'

  def new
    authorize @collection, :update?

    @graph = @collection.graphs.new
  end

  def edit
    authorize @collection, :update?
  end

  def create
    authorize @collection, :update?

    @graph = @collection.graphs.new(graph_params)

    if @graph.save
      flash[:notice] = 'Your graph was created'
      redirect_to [:metrics, @collection]
    else
      flash[:alert] = 'Your graph was not created. Please fix the errors'
      render :new
    end
  end

  # missing a template
  def index
    authorize @collection

    @graphs = @collection.graphs
  end

  def update
    authorize @collection

    if @graph.update(graph_params)
      flash[:notice] = 'Your graph was updated'
      redirect_to [:metrics, @graph.collection]
    else
      flash[:alert] = 'Your graph was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @collection, :update?

    @graph.destroy
    redirect_to :back
  end

  def data
    respond_to do |format|
      format.json {
        render json: @graph.data(params[:date_range])
      }
    end
  end

  def export_csv
    date_range = params[:date_range]
    unset_series = params.dig(:unset_series) || []

    GraphDownloadJob.perform_later(current_user.id, @graph.id, date_range, unset_series)

    render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
  end

  def group_population
    GroupPopulationGraph.data
  end

  protected

  def set_collection
    if params[:metrics_dashboard_id]
      @collection = current_user.enterprise.metrics_dashboards.find(params[:metrics_dashboard_id])
    elsif params[:poll_id]
      @collection = current_user.enterprise.polls.find(params[:poll_id])
    elsif @graph.metrics_dashboard_id
      @collection = current_user.enterprise.metrics_dashboards.find(@graph.metrics_dashboard_id)
    elsif @graph.poll_id
      @collection = current_user.enterprise.polls.find(@graph.poll_id)
    end
  end

  def set_graph
    @graph = Graph.find(params[:id])
  end

  def graph_params
    params
      .require(:graph)
      .permit(
        :field_id,
        :aggregation_id,
        :date_range,
        :unset_series
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Metric Graph List'
    when 'edit'
      'Metric Graph Edit'
    when 'new'
      'Metric Graph Creation'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
