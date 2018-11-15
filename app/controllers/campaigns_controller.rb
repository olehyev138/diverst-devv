class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:edit, :update, :destroy, :show, :contributions_per_erg, :top_performers]
  after_action :verify_authorized

  layout :resolve_layout

  def index
    authorize Campaign
    @campaigns = policy_scope(Campaign)
  end

  def new
    authorize Campaign
    @campaign = current_user.enterprise.campaigns.new
    @campaign.start = Date.today + 1
    @campaign.end = @campaign.start + 7.days
  end

  def create
    authorize Campaign
    @campaign = current_user.enterprise.campaigns.new(campaign_params)
    #TODO Remove. Hack to make question validation pass
    @campaign.questions.each { |q| q.campaign = @campaign }
    @campaign.owner = current_user

    if @campaign.save
      track_activity(@campaign, :create)
      flash[:notice] = "Your campaign was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your campaign was not created. Please fix the errors"
      render :new
    end
  end

  def show
    authorize @campaign
    @questions = @campaign.questions.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    authorize @campaign
  end

  def update
    authorize @campaign
    if @campaign.update(campaign_params)
      track_activity(@campaign, :update)
      flash[:notice] = "Your campaign was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your campaign was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    authorize @campaign

    track_activity(@campaign, :destroy)
    @campaign.destroy
    redirect_to action: :index
  end

  def contributions_per_erg
    authorize @campaign, :show?

    respond_to do |format|
      format.json {
        render json: {
          highcharts: @campaign.contributions_per_erg,
          type: 'pie'
        }
      }
      format.csv {
        CampaignContributionsDownloadJob.perform_later(current_user.id, @campaign.id, c_t(:erg))
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def top_performers
    authorize @campaign, :show?

    respond_to do |format|
      format.json {
        render json: {
          highcharts: @campaign.top_performers,
          type: 'bar'
        }
      }
      format.csv {
        CampaignTopPerformersDownloadJob.perform_later(current_user.id, @campaign.id)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  protected

  def set_campaign
    if current_user
      @campaign = current_user.enterprise.campaigns.find(params[:id])
    else
      user_not_authorized
    end
  end

  def campaign_params
    params
      .require(:campaign)
      .permit(
        :title,
        :description,
        :start,
        :end,
        :nb_invites,
        :image,
        :banner,
        :status,
        group_ids: [],
        segment_ids: [],
        manager_ids: [],
        questions_attributes: [
          :id,
          :_destroy,
          :title,
          :description
        ]
      )
  end

  def resolve_layout
    return 'user' if current_user.nil?
    'collaborate'
  end
end
