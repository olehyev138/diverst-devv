class Groups::GroupMessagesController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_group
  before_action :set_message, only: [:show, :destroy, :edit, :update]

  layout 'erg'

  def index
    @messages = @group.messages.includes(:owner).order(created_at: :desc).page(0)
  end

  def show
    @comments = @message.comments.includes(:author)

    @new_comment = GroupMessageComment.new
  end

  def new
    @message = @group.messages.new
  end

  def edit
    authorize @message, :update?
  end

  def create
    @message = @group.messages.new(message_params)
    @message.owner = current_user

    if @message.save
      user_rewarder("message_post").add_points(@message)
      UserGroupInstantNotificationJob.perform_later(@group, messages_count: 1)
      flash_reward "Your message was created. Now you have #{ current_user.credits } points"
      redirect_to action: :index
    else
      flash[:alert] = "Your message was not created. Please fix the errors"
      render :new
    end
  end

  def update
    authorize @message, :update?
    if @message.update(message_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    user_rewarder("message_post").remove_points(@message)
    @message.destroy
    flash[:notice] = "Your message was removed. Now you have #{ current_user.credits } points"

    redirect_to :back
  end

  def create_comment
    @message = @group.messages.find(params[:group_message_id])

    @comment = GroupMessageComment.new(message_comments_params)
    @comment.author = current_user

    @message.comments << @comment
    user_rewarder("message_comment").add_points(@comment)
    flash_reward "Your comment was created. Now you have #{ current_user.credits } points"

    redirect_to group_group_message_path(@group, @message)
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_message
    @message = @group.messages.find(params[:id])
  end

  def message_params
    params
      .require(:group_message)
      .permit(
        :subject,
        :content,
        segment_ids: []
      )
  end

  def message_comments_params
    params
      .require(:group_message_comment)
      .permit(
        :content
      )
  end
end
