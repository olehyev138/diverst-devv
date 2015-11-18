class Employee::CampaignsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_campaign, only: [:edit, :update, :destroy, :show]

  layout "employee"

  def index
    @campaigns = current_employee.campaigns
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
