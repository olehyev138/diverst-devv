class AnswerCommentsController < ApplicationController
  # before_action :authenticate_admin!
  before_action :set_comment_and_answer

  def destroy
    @comment.destroy
    redirect_to @answer
  end

  protected

  def set_comment_and_answer
    @comment = current_user.answer_comments.find(params[:id])
    @answer = @comment.answer
  end

  def comment_params
    params
      .require(:answer_comment)
      .permit(
        :content
      )
  end
end
