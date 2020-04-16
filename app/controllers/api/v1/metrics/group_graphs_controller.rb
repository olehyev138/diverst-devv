class Api::V1::Metrics::GroupGraphsController < DiverstController
  include Api::V1::Concerns::Metrics

  # Overview

  def group_population
    authorize MetricsDashboard, :index?

    render json: Graph.group_population
  end

  def views_per_group
    authorize MetricsDashboard, :index?

    render json: @graph.views_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def growth_of_groups
    authorize MetricsDashboard, :index?

    render json: @graph.growth_of_groups(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  # Initiatives

  def initiatives_per_group
    authorize MetricsDashboard, :index?

    render json: @graph.initiatives_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  # Social Media

  def messages_per_group
    authorize MetricsDashboard, :index?

    render json: @graph.messages_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def views_per_news_link
    authorize MetricsDashboard, :index?

    render json: @graph.views_per_news_link(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  # Resources

  def views_per_folder
    authorize MetricsDashboard, :index?

    render json: @graph.views_per_folder(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def views_per_resource
    authorize MetricsDashboard, :index?

    render json: @graph.views_per_resource(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def growth_of_resources
    authorize MetricsDashboard, :index?

    render json: @graph.growth_of_resources(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end
end
