class CampaignsController < ApplicationController
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
  end

  def create
    authorize Campaign
    @campaign = current_user.enterprise.campaigns.new(campaign_params)
    @campaign.owner = current_user

    if @campaign.save
      track_activity(@campaign, :create)
      redirect_to action: :index
    else
      render :edit
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
      redirect_to action: :index
    else
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
    render json: {
      highcharts: @campaign.contributions_per_erg,
      type: 'pie'
    }
  end

  def top_performers
    authorize @campaign, :show?
    render json: {
      highcharts: @campaign.top_performers,
      type: 'bar'
    }
  end

  protected

  def set_campaign
    @campaign = current_user.enterprise.campaigns.find(params[:id])
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
