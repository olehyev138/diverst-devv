class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:edit, :update, :destroy, :show, :contributions_per_erg, :top_performers]
  after_action :verify_authorized

  layout :resolve_layout

  def index
    authorize Campaign
    @campaigns = policy_scope(Campaign)

    respond_to do |format|
      format.html { visit_page('Campaigns') }
      format.json { render json: { data: @campaigns.limit(10).map { |c| [c.id, c.title ] } } }
    end
  end

  def new
    authorize Campaign
    visit_page('Campaign Creation')
    @campaign = current_user.enterprise.campaigns.new
    @campaign.start = Date.today + 1
    @campaign.end = @campaign.start + 7.days
  end

  def create
    authorize Campaign
    @campaign = current_user.enterprise.campaigns.new(campaign_params)
    # TODO Remove. Hack to make question validation pass
    @campaign.questions.each { |q| q.campaign = @campaign }
    @campaign.owner = current_user

    if @campaign.save
      track_activity(@campaign, :create)
      flash[:notice] = 'Your campaign was created'
      redirect_to action: :index
    else
      flash[:alert] = 'Your campaign was not created. Please fix the errors'
      render :new
    end
  end

  def show
    authorize @campaign
    visit_page("Campaign: #{@campaign.name}")
    @questions = @campaign.questions.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    authorize @campaign
    visit_page('Campaign Edit')
  end

  def update
    authorize @campaign
    if @campaign.update(campaign_params)
      track_activity(@campaign, :update)
      flash[:notice] = 'Your campaign was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'Your campaign was not updated. Please fix the errors'
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

    graph = Graph.new
    graph.enterprise_id = current_user.enterprise_id

    respond_to do |format|
      format.json {
        render json: graph.contributions_per_erg(@campaign)
      }
      format.csv {
        CampaignContributionsDownloadJob.perform_later(current_user.id, @campaign.id, c_t(:erg))
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  def top_performers
    authorize @campaign, :show?

    graph = Graph.new
    graph.enterprise_id = current_user.enterprise_id

    respond_to do |format|
      format.json {
        render json: graph.top_performers(@campaign)
      }
      format.csv {
        CampaignTopPerformersDownloadJob.perform_later(current_user.id, @campaign.id)
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
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
        :status,
        :input,
        group_ids: [],
        segment_ids: [],
        manager_ids: [],
        questions_attributes: [
          :id,
          :_destroy,
          :title,
          :description
        ],
        sponsors_attributes: [
          :id,
          :sponsor_name,
          :sponsor_title,
          :sponsor_message,
          :sponsor_media,
          :disable_sponsor_message,
          :_destroy
        ]
      )
  end

  def resolve_layout
    return 'user' if current_user.nil?

    'collaborate'
  end
end
