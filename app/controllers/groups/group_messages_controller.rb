class Groups::GroupMessagesController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_group
  before_action :set_message, only: [:show, :destroy, :edit, :update, :archive]
  after_action :visit_page, only: [:index, :show, :new, :edit]

  layout 'erg'

  def index
    @messages = @group.messages.includes(:owner).order(created_at: :desc).page(0)
  end

  def show
    @tags = @message.news_tags

    @comments = @message.comments.includes(:author)

    @new_comment = GroupMessageComment.new

    @message.increment_view(current_user)
  end

  def new
    @message = @group.messages.new
    @message.build_news_feed_link(news_feed_id: @group.news_feed.id)
  end

  def edit
    authorize [@group, @message], :update?, policy_class: GroupMessagePolicy
  end

  def create
    @message = @group.messages.new(message_params)
    @message.owner = current_user
    add_tags(tag_params)

    if @message.save
      track_activity(@message, :create)
      user_rewarder('message_post').add_points(@message)
      flash_reward "Your message was created. Now you have #{current_user.credits} points"
      redirect_to group_posts_path(@group)
    else
      flash[:alert] = 'Your message was not created. Please fix the errors'
      render :new
    end
  end

  def update
    authorize [@group, @message], :update?, policy_class: GroupMessagePolicy
    add_tags(tag_params)
    if @message.update(message_params)
      track_activity(@message, :update)
      redirect_to group_posts_path(@group)
    else
      flash[:alert] = 'Your message was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    track_activity(@message, :destroy)
    user_rewarder('message_post').remove_points(@message)
    @message.destroy
    flash[:notice] = "Your message was removed. Now you have #{current_user.credits} points"

    redirect_to group_posts_path(@group)
  end

  def create_comment
    @message = @group.messages.find(params[:group_message_id])

    @comment = @message.comments.new(message_comments_params)
    @comment.author = current_user

    if @comment.save
      user_rewarder('message_comment').add_points(@comment)
      flash_reward "Your comment was created. Now you have #{current_user.credits} points"
    else
      flash[:alert] = 'Comment not saved. Please fix errors'
    end

    redirect_to group_group_message_path(@group, @message)
  end

  def archive
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @message.news_feed_link.update(archived_at: DateTime.now)
    track_activity(@message, :archive)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_message
    @message = @group.messages.find(params[:id])
  end

  def add_tags(params)
    return if params.blank?

    tags = params[:news_feed_link_attributes][:news_tag_ids]
    tag_records = []
    tags.map { |i| i.downcase }.uniq.each do |tag|
      next if tag == ''

      tag_records << NewsTag.find_or_create_by(name: tag)
    end
    @message.news_feed_link.news_tags = tag_records
  end

  def message_params
    params
        .require(:group_message)
        .permit(
          :subject,
          :content,
          news_feed_link_attributes: [:id, :approved, :news_feed_id, :link, shared_news_feed_ids: [], segment_ids: []],
        )
  end

  def tag_params
    params
      .require(:group_message)
      .permit(
        news_feed_link_attributes: [news_tag_ids: []],
      )
  end

  def message_comments_params
    params
        .require(:group_message_comment)
        .permit(
          :content
        )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Messages"
    when 'show'
      "#{@message.to_label}"
    when 'new'
      'Message Creation'
    when 'edit'
      "Edit Message: #{@message.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
