class Metrics::SegmentGraphsController < ApplicationController
  include Metrics

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
end
