class MentoringRequestsController < ApplicationController
  before_action :set_mentoring_request, only: [:update, :destroy]
  
  layout "user"
  
  def new
    @mentoring_request = MentoringRequest.new(:sender_id => params[:sender_id], :receiver_id => params[:receiver_id])
    render 'user/mentorship/mentors/new'
  end
  
  def create
    @mentoring_request = current_user.enterprise.mentoring_requests.new(mentoring_request_params)
    @mentoring_request.status = "pending"
    if @mentoring_request.save
      redirect_to mentees_user_mentorship_index_path
    else
      flash[:alert] = @mentoring_request.errors.full_messages.first
      render 'user/mentorship/mentors/new'
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
  
  def mentoring_request_params
    params.require(:mentoring_request).permit(:notes, :sender_id, :receiver_id)
  end
  
  def set_mentoring_request
    @mentoring_request = current_user.enterprise.mentoring_requests.find(params[:id])
  end
  
end