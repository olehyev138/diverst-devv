class Groups::SocialLinksController < ApplicationController
  include Rewardable

  before_action :authenticate_user!

  before_action :set_group
  before_action :set_social_link, only: [:destroy, :archive]
  after_action :visit_page, only: [:index, :new]

  layout 'erg'

  def index
    @posts = @group.social_links.order(updated_at: :desc)
  end

  def new
    @social_link = @group.social_links.new
    @links = SocialMedia::Importer.oembed_link_short
  end

  def create
    @social_link = @group.social_links.new(social_link_params)
    @social_link.author = current_user
    @links = SocialMedia::Importer.oembed_link

    if @social_link.save
      track_activity(@social_link, :create)
      user_rewarder('social_media_posts').add_points(@social_link)
      flash_reward "Your social_link was created. Now you have #{ current_user.credits } points"
      redirect_to group_posts_path(@group)
    else
      flash[:alert] = 'Your social link was not created. Please fix the errors'
      render :new
    end
  end

  def destroy
    track_activity(@social_link, :destroy)
    @social_link.destroy
    flash[:notice] = 'Your social link was removed.'
    redirect_to group_posts_path(@group)
  end

  def archive
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @social_link.news_feed_link.update(archived_at: DateTime.now)
    track_activity(@social_link, :archive)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_social_link
    @social_link = @group.social_links.find(params[:id])
  end

  def social_link_params
    params
        .require(:social_link)
        .permit(
          :url,
          news_feed_link_attributes: [:id, :approved, :news_feed_id, :link, shared_news_feed_ids: [], segment_ids: []],
        )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Social Links"
    when 'new'
      "#{@group.to_label}'s Social Link Creation"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
