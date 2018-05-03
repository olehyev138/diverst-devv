class MentoringSessionsController < ApplicationController
  before_action :set_mentoring_session, only: [:show, :update, :destroy]
  
  layout "user"
  
  def new
    @mentoring_session = current_user.mentoring_sessions.new
    render 'user/mentorship/sessions/new'
  end
  
  def show
    render 'user/mentorship/sessions/show'
  end
  
  def create
    @mentoring_session = current_user.enterprise.mentoring_sessions.new(mentoring_session_params)
    @mentoring_session.status = "scheduled"
    @mentoring_session.enterprise_id = current_user.enterprise_id
    @mentoring_session.creator_id = current_user.id
    
    if @mentoring_session.save
      redirect_to sessions_user_mentorship_index_path
    else
      flash[:alert] = "Your session was not scheduled"
      render 'user/mentorship/sessions/new'
    end
  end
  
  def update
  end
  
  def destroy
    @mentoring_session.destroy
    redirect_to :back
  end
  
  private
  
  def mentoring_session_params
    params.require(:mentoring_session).permit(
      :notes, 
      :start, 
      :end, 
      :format,
      mentoring_interest_ids: [],
      resources_attributes: [
        :id,
        :title,
        :file,
        :url,
        :_destroy
      ],
      mentorship_sessions_attributes: [
        :id,
        :user_id,
        :attending,
        :_destroy
      ]
    )
  end
  
  def set_mentoring_session
    @mentoring_session = current_user.mentoring_sessions.find(params[:id])
  end
  
end