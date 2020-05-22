class Api::V1::Metrics::GroupGraphsController < DiverstController
  include Api::V1::Concerns::Metrics

  # Overview

  def group_overview_metrics
    authorize MetricsDashboard, :index?

    render status: 200, json: {
        total_groups: current_user.enterprise.groups.size,
        avg_nb_members_per_group: Group.avg_members_per_group(enterprise: current_user.enterprise)
    }
  end

  def group_specific_metrics
    authorize MetricsDashboard, :index?

    render status: 200, json: {}
  end

  def group_population
    authorize MetricsDashboard, :index?

    render status: 200, json: Graph.group_population
  end

  def views_per_group
    authorize MetricsDashboard, :index?

    render status: 200, json: @graph.views_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def growth_of_groups
    authorize MetricsDashboard, :index?

    render json: Graph.growth_of_groups
  end

  # Initiatives

  def initiatives_per_group
    authorize MetricsDashboard, :index?

    render json: @graph.initiatives_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  # Social Media

  def news_posts_per_group
    authorize MetricsDashboard, :index?

    render json: Graph.news_posts_per_group
  end

  def views_per_news_link
    authorize MetricsDashboard, :index?

    render json: @graph.views_per_news_link(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  # Resources

  def views_per_folder
    authorize MetricsDashboard, :index?

    render status: 200, json: Graph.views_per_folder
  end

  def views_per_resource
    authorize MetricsDashboard, :index?

    render json: @graph.views_per_resource(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def growth_of_resources
    authorize MetricsDashboard, :index?

    render json: @graph.growth_of_resources(metrics_params[:date_range], metrics_params[:scoped_by_models])
  end

  def payload
    params
        .require(klass.symbol)
        .permit(:group)
  end
end
