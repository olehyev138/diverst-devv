class CampaignsController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]
  before_action :set_campaign, only: [:edit, :update, :destroy, :show, :contributions_per_erg, :top_performers]

  layout :resolve_layout

  def index
    @campaigns = current_user.enterprise.campaigns
  end

  def new
    @campaign = current_user.enterprise.campaigns.new
  end

  def create
    @campaign = current_user.enterprise.campaigns.new(campaign_params)

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
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to action: :index
  end

  def contributions_per_erg
    render json: {
      highcharts: @campaign.contributions_per_erg,
      type: "pie"
    }
  end

  def top_performers
    render json: {
      highcharts: @campaign.top_performers,
      type: "bar"
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

  def resolve_layout
    return "employee" if current_admin.nil?
    "unify"
  end
end
