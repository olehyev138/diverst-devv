class Metrics::CampaignGraphsController < ApplicationController
  include Metrics
  before_action :set_campaign

  layout 'metrics'

  def index
    authorize MetricsDashboard
  end

  def contributions_per_erg
    authorize MetricsDashboard, :index?
    authorize @campaign, :show?

    respond_to do |format|
      format.json {
        render json: @graph.contributions_per_erg(@campaign)
      }
      format.csv {
        CampaignContributionsDownloadJob.perform_later(current_user.id, @campaign.id, c_t(:erg))
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  def total_votes_per_user
    authorize MetricsDashboard, :index?
    authorize @campaign, :show?

    respond_to do |format|
      format.json {
        render json: @graph.top_performers(@campaign)
      }
      format.csv {
        CampaignTopPerformersDownloadJob.perform_later(current_user.id, @campaign.id)
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  private

  def set_campaign
    passed_campaign_id = metrics_params[:scoped_by_models[0]]
    @campaign = passed_campaign_id.present? ? Campaign.find(passed_campaign_id) : Campaign.first
  end
end
