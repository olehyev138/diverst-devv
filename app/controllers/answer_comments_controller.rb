class AnswerCommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_comment_and_answer

  def update
    if @comment.update(comment_params)
        flash[:notice] = "The comment was updated"
        redirect_to :back
    else
        flash[:alert] = "The comment was not updated"
        redirect_to :back
    end
  end

  def destroy
    @comment.destroy
    redirect_to @answer
  end

  protected

  def set_comment_and_answer
    if current_user
      @comment = current_user.enterprise.answer_comments.find(params[:id])
      @answer = @comment.answer
    else
      user_not_authorized
    end
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
