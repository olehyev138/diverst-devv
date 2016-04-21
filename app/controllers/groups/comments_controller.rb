class Groups::CommentsController < ApplicationController
  before_action :set_group
  before_action :set_event
  before_action :set_comment, only: [:edit, :update, :show]

  layout 'erg'

  def create
    @comment = @event.comments.new(comment_params)
    @comment.user = current_user

    @comment.save
    redirect_to :back
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_event
    @event = @group.events.find(params[:event_id])
  end

  def comment_params
    params.require(:event_comment).permit(
      :content
    )
  end
end
