class Metrics::SegmentGraphsController < ApplicationController
  include Metrics

  after_action :visit_page, only: [:index]

  layout 'metrics'

  def index
    authorize MetricsDashboard, :index?

    @data = {
      segment_count: current_user.enterprise.segments.size
    }
  end

  def segment_population
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.segment_population
      }
      format.csv {
        GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_segment_population)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Segment Metrics'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
