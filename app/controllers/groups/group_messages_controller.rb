class Groups::GroupMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_message, only: [:show, :destroy]

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

  def create
    @message = @group.messages.new(message_params)
    @message.owner = current_user

    if @message.save
      flash[:notice] = "Your message was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your message was not created. Please fix the errors"
      render :new
    end
  end

  def destroy
    @message.destroy

    redirect_to :back
  end

  def create_comment
    @message = @group.messages.find(params[:group_message_id])

    @comment = GroupMessageComment.new(message_comments_params)
    @comment.author = current_user

    @message.comments << @comment

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
