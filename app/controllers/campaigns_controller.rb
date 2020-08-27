class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:edit, :update, :destroy, :show,
                                      :contributions_per_erg, :top_performers, :graphs,
                                      :users_to_invite_to_collaborate, :invite_users]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :show, :edit]

  include Rewardable

  layout :resolve_layout

  def index
    authorize Campaign
    @campaigns = policy_scope(Campaign)

    respond_to do |format|
      format.html
      format.json { render json: { data: @campaigns.limit(10).map { |c| [c.id, c.title ] } } }
    end
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
    @questions = @campaign.questions.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    authorize @campaign
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

  def stats
    authorize Campaign
    @campaigns = policy_scope(Campaign)

    respond_to do |format|
      format.html
      format.json { render json: { data: @campaigns.limit(10).map { |c| [c.id, c.title ] } } }
    end
  end

  def graphs
    authorize @campaign, :show?
  end

  def view_all_graphs
    authorize Campaign
  end

  def engagement_activity_distribution
    authorize Campaign

    render json: Campaign.engagement_activity_distribution(current_user.enterprise_id, nil, params[:date_range]).symbolize_keys
  end

  def roi_distribution
    authorize Campaign

    render json: Campaign.roi_distribution(current_user.enterprise_id, nil, params[:date_range]).symbolize_keys
  end

  def users_to_invite_to_collaborate
    authorize @campaign, :show?

    @users_to_invite = current_user.enterprise.users.joins(:user_role).where(user_roles: { role_name: 'Admin' })

    respond_to do |format|
      format.html
      format.json { render json: UsersToInviteToCollaborateDatatable.new(view_context, @campaign, @users_to_invite) }
    end
  end

  def invite_users
    authorize @campaign, :show?

    CampaignCollaboratorsInvitationJob.perform_later(@campaign.id, params[:user_id].to_i)

    render nothing: true, status: :ok
  end

  def engagement_distribution_per_campaign
    authorize Campaign

    campaign = Campaign.find_by(title: params[:campaign_title])

    render json: campaign&.activities_distribution_per_campaign&.symbolize_keys, status: :ok
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
        :image_alt_text_desc,
        :banner_alt_text_desc,
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Campaigns'
    when 'new'
      'Campaign Creation'
    when 'show'
      "Campaign: #{@campaign.to_label}"
    when 'edit'
      'Campaign Edit'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
