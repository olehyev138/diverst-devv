class User::AnswerCommentsController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_answer

  layout 'user'

  def create
    @comment = @answer.comments.new(comment_params)
    @comment.author = current_user
    @comment.save && user_rewarder("campaign_comment").add_points(@comment)
    flash_reward "Your comment was created. Now you have #{ current_user.credits } points"

    redirect_to [:user, @answer.question]
  end

  protected

  def set_answer
    @answer = Answer.find(params[:answer_id])
    return head 403 if @answer.question.campaign.users.where(id: current_user.id).count < 1
  end

  def comment_params
    params
      .require(:answer_comment)
      .permit(
        :content
      )
  end
end
