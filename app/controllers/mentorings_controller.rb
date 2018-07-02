class MentoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mentoring_request, only: [:update, :destroy]
  
  def index
    @users = current_user.enterprise.users.enterprise_mentors([current_user.id] + current_user.mentors.ids) if params[:mentor]
    @users = current_user.enterprise.users.enterprise_mentees([current_user.id] + current_user.mentees.ids) if params[:mentee]
    
    respond_to do |format|
      format.json { render json: MentoringDatatable.new(view_context, @users, current_user) }
    end
  end
  
  def update
    authorize current_user
    
    # we either add the user as a mentor or mentee
    
    if @mentoring_request.sender_id === current_user.id
        current_user.mentorships.create!(:mentee_id => @mentoring_request.receiver_id, :mentor_id => current_user.id)
    else
        current_user.mentorships.create!(:mentor_id => @mentoring_request.sender_id, :mentee_id => current_user.id)
    end
    
    
    flash[:notice] = "Your request was approved"
    # we then destroy the request
    destroy
  end
  
  def destroy
    @mentoring_request.destroy
    redirect_to :back
  end
  
  private
  
  def set_mentoring_request
    @mentoring_request = current_user.enterprise.mentoring_requests.find(params[:id])
  end
  
  def search_params
      params.permit(:mentor, :mentee)
  end
end