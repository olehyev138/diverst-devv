class Metrics::GroupGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index]

  layout 'metrics'

  def overview
  end

  def initiatives
  end

  def social_media
  end

  def resources
  end

  # Metric actions
  # Overview

  def group_population
    respond_to do |format|
      format.json {
        render json: @graph.group_population(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  def views_per_group
    respond_to do |format|
      format.json {
        render json: @graph.views_per_group(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  def growth_of_groups
    respond_to do |format|
      format.json {
        render json: @graph.growth_of_groups(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  # Initiatives

  def initiatives_per_group
    respond_to do |format|
      format.json {
        render json: @graph.initiatives_per_group(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  # Social Media

  def messages_per_group
    respond_to do |format|
      format.json {
        render json: @graph.messages_per_group(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  def views_per_news_link
    respond_to do |format|
      format.json {
        render json: @graph.views_per_news_link(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  # Resources

  def views_per_folder
    respond_to do |format|
      format.json {
        render json: @graph.views_per_folder(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  def views_per_resource
    respond_to do |format|
      format.json {
        render json: @graph.views_per_resource(group_params[:date_range], group_params[:scoped_by_models])
      }
    end
  end

  def growth_of_resources
    respond_to do |format|
      format.json {
        render json: @graph.growth_of_resources(group_params[:date_range], group_params[:scoped_by_models])
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
