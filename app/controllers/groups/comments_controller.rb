class Groups::CommentsController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_group, except: [:destroy]
  before_action :set_event, except: [:destroy]
  before_action :set_comment, only: [:destroy]

  layout 'erg'

  def create
    authorize [@group], :destroy?, policy_class: InitiativeCommentPolicy

    @comment = @event.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      user_rewarder('feedback_on_event').add_points(@comment)
      flash_reward "Your comment was created. Now you have #{ current_user.credits } points"
    else
      flash[:alert] = 'Your comment was not created. Please fix the errors'
    end

    redirect_to :back
  end

  def destroy
    authorize [@comment.initiative.owner_group, @comment], :destroy?, policy_class: InitiativeCommentPolicy

    @comment.destroy
    flash[:notice] = 'You just deleted a comment'
    redirect_to :back
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
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
