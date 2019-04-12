class Metrics::GroupGraphsController < ApplicationController
  include Metrics

  layout 'metrics'

  def index
    authorize MetricsDashboard

    @group_metrics = {
      total_groups: current_user.enterprise.groups.count,
      avg_nb_members_per_group: Group.avg_members_per_group(enterprise: current_user.enterprise)
    }
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
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.group_population(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsGroupPopulationDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_group_population)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def views_per_group
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.views_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsTopGroupsByViewsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          false,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_top_groups_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def growth_of_groups
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.growth_of_groups(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsGroupGrowthDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_group_growth)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  # Initiatives

  def initiatives_per_group
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.initiatives_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsEventsCreatedDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          false,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_events_created)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  # Social Media

  def messages_per_group
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.messages_per_group(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsMessagesSentDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          false,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_messages_sent)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def views_per_news_link
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.views_per_news_link(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsTopNewsByViewsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          false,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_top_news_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  # Resources

  def views_per_folder
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.views_per_folder(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsTopFoldersByViewsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          false,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_top_folders_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def views_per_resource
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.views_per_resource(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
      format.csv {
        GenericGraphsTopResourcesByViewsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          false,
          @from_date,
          @to_date,
          metrics_params[:scoped_by_models]
        )
        track_activity(current_user.enterprise, :export_generic_graphs_top_resources_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def growth_of_resources
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.growth_of_resources(metrics_params[:date_range], metrics_params[:scoped_by_models])
      }
    end
  end
end
