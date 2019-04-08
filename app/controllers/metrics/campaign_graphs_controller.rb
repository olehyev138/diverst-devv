class Metrics::CampaignGraphsController < ApplicationController
  before_action :authenticate_user! # TODO: check this works
  before_action :set_graph, except: [:index] # TODO: fix
  before_action :set_campaign

  layout 'metrics'

  def index
  end

  def contributions_per_erg
    authorize @campaign, :show?

    respond_to do |format|
      format.json {
        render json: @graph.contributions_per_erg(@campaign)
      }
      format.csv {
        CampaignContributionsDownloadJob.perform_later(current_user.id, @campaign.id, c_t(:erg))
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def total_votes_per_user
    authorize @campaign, :show?

    respond_to do |format|
      format.json {
        render json: @graph.top_performers(@campaign)
      }
      format.csv {
        CampaignTopPerformersDownloadJob.perform_later(current_user.id, @campaign.id)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  private

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def set_campaign
    passed_campaign_id = campaign_params[:scoped_by_models[0]]
    @campaign = passed_campaign_id.present? ? Campaign.find(passed_campaign_id) : Campaign.first
  end

  def campaign_params
    params.permit(
      scoped_by_models: []
    )
  end
end
