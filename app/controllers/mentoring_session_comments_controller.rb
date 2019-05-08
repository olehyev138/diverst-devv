class MentoringSessionCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mentoring_session, :set_comment

  layout 'user'

  def edit
    authorize @comment

    render 'user/mentorship/session_comments/edit'
  end

  def update
    authorize @comment

    if @comment.update(comment_params)
      flash[:notice] = 'Your comment was updated'
      redirect_to mentoring_session_path(@mentoring_session)
    else
      flash[:alert] = 'Your comment was not updated. Please fix the errors'
      render 'user/mentorship/session_comments/edit'
    end
  end

  def destroy
    authorize @comment

    @comment.destroy
    redirect_to mentoring_session_path(@mentoring_session)
  end

  protected

  def set_mentoring_session
    @mentoring_session = current_user.mentoring_sessions.find(params[:mentoring_session_id])
  end

  def set_comment
    @comment = @mentoring_session.comments.find(params[:id])
  end

  def comment_params
    params
        .require(:mentoring_session_comment)
        .permit(
          :content
        )
  end
end
