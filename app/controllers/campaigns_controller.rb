class CampaignsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_campaign, only: [:edit, :update, :destroy, :show]

  layout "unify"

  def index
    @campaigns = current_admin.enterprise.campaigns
  end

  def new
    @campaign = current_admin.enterprise.campaigns.new
  end

  def create
    @campaign = current_admin.enterprise.campaigns.new(campaign_params)

    if @campaign.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    @questions = @campaign.questions.order(created_at: :desc).page(params[:page]).per(10)
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to action: :index
  end

  protected

  def set_campaign
    @campaign = current_admin.enterprise.campaigns.find(params[:id])
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
      group_ids: [],
      segment_ids: [],
      questions_attributes: [
        :id,
        :_destroy,
        :title,
        :description
      ]
    )
  end
end
