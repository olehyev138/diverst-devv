class MentoringSessionRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mentoring_session_request, only: [:accept, :decline]
  before_action :set_mentoring_session, only: [:accept, :decline]

  def accept
    authorize @mentoring_session_request

    @mentoring_session_request.accept
    @mentoring_session_request.save

    flash[:notice] = "Session invitation accepted"
    redirect_to :back
  end

  def decline
    authorize @mentoring_session_request

    @mentoring_session_request.decline
    @mentoring_session_request.save

    flash[:notice] = "Session invitation declined"
    redirect_to mentoring_sessions_path
  end

  private

  def set_mentoring_session_request
    @mentoring_session_request = current_user.mentoring_session_requests.find(params[:id])
  end

  def set_mentoring_session
    @mentoring_session = current_user.enterprise.mentoring_sessions.find(params[:mentoring_session_id])
  end
end
