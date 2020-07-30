class User::UserAnswerCommentsController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_answer, only: [:create]

  layout 'user'

  def create
    @comment = @answer.comments.new(comment_params)
    @comment.author = current_user
    if @comment.save
      user_rewarder('campaign_comment').add_points(@comment)
      track_activity(@comment, :create)
      flash_reward "Your comment was created. Now you have #{current_user.credits} points"
    else
      flash[:alert] = 'Your comment was not created. Please fix the errors'
    end

    redirect_to [:user, @answer.question]
  end

  def approve
    @comment = AnswerComment.find(params[:id])
    @comment.update(approved: true)
    flash[:notice] = 'You approved a comment'
    
    redirect_to :back
  end

  protected

  def set_answer
    @answer = Answer.find(params[:user_answer_id])
  end

  def comment_params
    params
        .require(:answer_comment)
        .permit(
          :content,
          :approved
        )
  end
end
