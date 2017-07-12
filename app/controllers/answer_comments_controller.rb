class AnswerCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def destroy
    @comment.destroy
    redirect_to :back
  end

  protected

  def set_comment
    @comment = current_user.enterprise.answer_comments.find(params[:id])
  end

  def comment_params
    params
      .require(:answer_comment)
      .permit(
        :content
      )
  end
end
