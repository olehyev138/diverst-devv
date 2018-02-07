class Groups::CommentsController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_group, except: [:approve, :disapprove, :destroy]
  before_action :set_event, except: [:approve, :disapprove, :destroy]
  before_action :set_comment, only: [:approve, :disapprove, :destroy]

  layout 'erg'

  def create
    @comment = @event.comments.new(comment_params)
    @comment.approved = true if current_user.erg_leader? #auto-approve comment of group leader
    @comment.user = current_user
    if @comment.save
      user_rewarder("feedback_on_event").add_points(@comment)
      flash_reward "Your comment was created. Now you have #{ current_user.credits } points"
    else
      flash[:alert] = "Your comment was not created. Please fix the errors"
    end

    redirect_to :back
  end

  def approve
    authorize @comment, :approve?

    @comment.update(approved: true)
    flash[:notice] = "You just approved a comment"
    redirect_to :back
  end

  def disapprove
    authorize @comment, :disapprove?

    @comment.update(approved: false)
    flash[:notice] = "You just disapproved a comment"
    redirect_to :back
  end

  def destroy
    authorize @comment, :destroy?

    @comment.destroy
    flash[:notice] = "You just deleted a comment"
    redirect_to :back
  end

  protected

  def set_group
    current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
  end

  def set_event
    @event = @group.initiatives.find(params[:event_id])
  end

  def set_comment
    @comment = InitiativeComment.find(params[:id])
  end

  def comment_params
    params.require(:initiative_comment).permit(:content, :approved)
  end
end
