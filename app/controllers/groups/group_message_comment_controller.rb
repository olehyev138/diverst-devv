class Groups::GroupMessageCommentController < ApplicationController
  before_action :set_group, :set_group_message
  after_action :visit_page, only: [:edit]

  layout 'erg'

  def edit
    @comment = @group_message.comments.find(params[:id])
  end

  def update
    @comment = @group_message.comments.find(params[:id])

    if @comment.update(comment_params)
      flash[:notice] = 'Your comment was updated'
      redirect_to group_group_message_url(id: @group_message, group_id: @group.id)
    else
      flash[:alert] = 'Your comment was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    @comment = @group_message.comments.find(params[:id])
    @comment.destroy
    redirect_to group_group_message_url(id: @group_message, group_id: @group.id)
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_group_message
    @group_message = @group.messages.find(params[:group_message_id])
  end

  def comment_params
    params
        .require(:group_message_comment)
        .permit(
          :content,
          :approved
        )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'edit'
      'Edit Group Message Comment'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
