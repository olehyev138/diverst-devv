class Metrics::SegmentGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index] # TODO: fix

  layout 'metrics'

  def index
    @data = {
      segment_count: current_user.enterprise.segments.count
    }
  end

  def segment_population
    respond_to do |format|
      format.json {
        render json: @graph.segment_population
      }
    end
  end

  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end
end
