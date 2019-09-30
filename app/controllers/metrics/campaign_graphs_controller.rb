class Metrics::CampaignGraphsController < ApplicationController
  include Metrics
  before_action :set_campaign
  after_action :visit_page, only: [:index]

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
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
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
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  private

  def set_campaign
    passed_campaign_id = metrics_params[:scoped_by_models[0]]
    @campaign = passed_campaign_id.present? ? Campaign.find(passed_campaign_id) : Campaign.first
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Campaign Metrics'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
