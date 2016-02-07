class User::AnswerCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer

  layout 'user'

  def create
    @comment = @answer.comments.new(comment_params)
    @comment.author = current_user
    @comment.save

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
