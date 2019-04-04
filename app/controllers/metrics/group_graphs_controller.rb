class Metrics::GroupGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index]

  layout 'metrics'

  # Views

  # - Overview
  #   - population
  #   - views per group
  #   - links to sub dashboards
  # - Initiatives
  #   - initiatives created per erg
  #   - upcoming, ongoing initiatives
  # - Social Media
  #   - # messages per group
  #   - # news links per group
  #   - # views per news link
  #   - table of messages
  #   - table of news links
  # - Resources
  #    - Views per folder
  #    - Views per resource
  #    - tables, other stats

  def overview
  end

  def initiatives
  end

  def social_media
  end

  def resources
  end

  # Metrics

  def group_population
    respond_to do |format|
      format.json {
        render json: @graph.group_population(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def group_params
    params.permit(
      date_range: [
        :from_date,
        :to_date
      ],
      scoped_by_models: []
    )
  end
end
