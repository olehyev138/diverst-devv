class Groups::CommentsController < ApplicationController
  include Rewardable

  before_action :set_group
  before_action :set_event
  before_action :set_comment, only: [:edit, :update, :show]

  layout 'erg'

  def create
    @comment = @event.comments.new(comment_params)
    @comment.user = current_user
    @comment.save && user_rewarder("feedback_on_event").add_points(@comment)
    flash_reward "Now you have #{ current_user.credits } points"

    redirect_to :back
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_event
    @event = @group.initiatives.find(params[:event_id])
  end

  def comment_params
    params.require(:initiative_comment).permit(
      :content
    )
  end
end
