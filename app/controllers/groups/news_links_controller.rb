class Groups::NewsLinksController < ApplicationController
  include Rewardable

  before_action :authenticate_user!

  before_action :set_group, except: [:url_info]
  before_action :set_news_link, only: [:comments, :create_comment, :edit, :update, :destroy, :news_link_photos, :archive]
  after_action :visit_page, only: [:index, :new, :edit, :comments]

  layout 'erg'

  def index
    @news_links = @group.news_links.includes(:author).order(created_at: :desc)
  end

  def new
    @news_link = @group.news_links.new
    @news_link.build_news_feed_link(news_feed_id: @group.news_feed.id)
  end

  def edit
  end

  def comments
    @tags = @news_link.news_tags
    @comments = @news_link.comments.includes(:author)
    @new_comment = NewsLinkComment.new
    @news_link.increment_view(current_user)
  end

  def create_comment
    @comment = @news_link.comments.new(news_link_comment_params)
    @comment.author = current_user

    if @comment.save
      user_rewarder('news_comment').add_points(@comment)
      flash_reward "Your comment was created. Now you have #{current_user.credits} points"
    else
      flash[:alert] = 'Your comment was not created. Please fix the errors'
    end

    redirect_to action: :comments
  end

  def create
    @news_link = @group.news_links.new(news_link_params)
    @news_link.author = current_user
    add_tags(tag_params)

    if @news_link.save
      track_activity(@news_link, :create)
      user_rewarder('news_post').add_points(@news_link)
      flash_reward "Your news was created. Now you have #{current_user.credits} points"
      redirect_to group_posts_path(@group)
    else
      flash[:alert] = 'Your news was not created. Please fix the errors'
      render :edit
    end
  end

  def update
    add_tags(tag_params)
    if @news_link.update(news_link_params)
      track_activity(@news_link, :update)
      flash[:notice] = 'Your news was updated'
      redirect_to group_posts_path(@group)
    else
      flash[:alert] = 'Your news was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    track_activity(@news_link, :destroy)
    user_rewarder('news_post').remove_points(@news_link)
    @news_link.destroy
    flash[:notice] = "Your news was removed. Now you have #{current_user.credits} points"
    redirect_to group_posts_path(@group)
  end

  # this is not a route found in config/routes.rb
  # Gets basic information about a web article (title and lede) from its url
  def url_info
    page = Pismo::Document.new(params[:url])

    render json: {
               title: page.title,
               description: page.lede
           }
  end

  def news_link_photos
    @resize = true
    @photos = @news_link.photos
  end

  def archive
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy

    @news_link.news_feed_link.update(archived_at: DateTime.now)
    track_activity(@news_link, :archive)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_news_link
    @news_link = @group.news_links.find(params[:id])
  end

  def add_tags(params)
    return if params.blank?

    tags = params[:news_feed_link_attributes][:news_tag_ids]
    tag_records = []
    tags.map { |i| i.downcase }.uniq.each do |tag|
      next if tag == ''

      tag_records << NewsTag.find_or_create_by(name: tag)
    end
    @news_link.news_feed_link.news_tags = tag_records
  end

  def news_link_params
    params
        .require(:news_link)
        .permit(
          :url,
          :title,
          :description,
          :picture,
          photos_attributes: [:file, :_destroy, :id],
          news_feed_link_attributes: [:id, :approved, :news_feed_id, :link, shared_news_feed_ids: [], segment_ids: []],
        )
  end

  def news_link_comment_params
    params
        .require(:news_link_comment)
        .permit(
          :content
        )
  end

  def tag_params
    params
      .require(:news_link)
      .permit(
        news_feed_link_attributes: [news_tag_ids: []],
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s News Links"
    when 'new'
      "#{@group.to_label}'s News Link Creation"
    when 'edit'
      "#{@group.to_label}'s News Link Edit"
    when 'comments'
      "#{@news_link.to_label}'s Comments"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
