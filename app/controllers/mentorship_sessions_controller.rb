class MentorshipSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mentoring_session, only: [:accept, :decline]
  before_action :set_mentorship_session, only: [:accept, :decline]

  def accept
    authorize @mentorship_session

    @mentorship_session.accept
    @mentorship_session.save

    flash[:notice] = 'Session invitation accepted'
    redirect_to :back
  end

  def decline
    authorize @mentorship_session

    @mentorship_session.decline
    @mentorship_session.save

    MentorMailer.session_declined(@mentoring_session.creator.id, @mentoring_session.id, current_user.id).deliver_later

    flash[:notice] = 'Session invitation declined'
    redirect_to :back
  end

  private

  def set_mentoring_session
    @mentoring_session = current_user.enterprise.mentoring_sessions.find(params[:mentoring_session_id])
  end

  def set_mentorship_session
    @mentorship_session = @mentoring_session.mentorship_sessions.find(params[:id])
  end
end
