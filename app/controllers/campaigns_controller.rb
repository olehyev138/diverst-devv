class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:edit, :update, :destroy, :show,
    :contributions_per_erg, :top_performers]
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

    data = @campaign.contributions_per_erg
    respond_to do |format|
      format.json {
        render json: {
          highcharts: data,
          type: 'pie'
        }
      }
      format.csv {
        flatten_data = data[:series].map{ |d| d[:data] }.flatten
        strategy = Reports::GraphStatsGeneric.new(
          title: 'Contributions per ERG',
          categories: flatten_data.map{ |d| d[:name] }.uniq,
          data: flatten_data.map{ |d| d[:y] }
        )
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "contributions_per_erg.csv"
      }
    end
  end

  def top_performers
    authorize @campaign, :show?

    data = @campaign.top_performers
    respond_to do |format|
      format.json {
        render json: {
          highcharts: data,
          type: 'bar'
        }
      }
      format.csv {
        strategy = Reports::GraphStatsGeneric.new(title: 'Top performers',
          categories: data[:categories], data: data[:series].map{ |d| d[:data] }.flatten)
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "top_performers.csv"
      }
    end
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
