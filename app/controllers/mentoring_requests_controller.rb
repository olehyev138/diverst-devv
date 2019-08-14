class MentoringRequestsController < ApplicationController
  before_action :set_mentoring_request, only: [:update, :destroy]
  after_action :visit_page, only: [:new]

  layout 'user'

  def new
    @mentoring_request = MentoringRequest.new(sender_id: params[:sender_id], receiver_id: params[:receiver_id], mentoring_type: params[:mentoring_type])

    if params[:mentoring_type] === 'mentor'
      render 'user/mentorship/mentors/new'
    else
      render 'user/mentorship/mentees/new'
    end
  end

  def create
    @mentoring_request = current_user.enterprise.mentoring_requests.new(mentoring_request_params)
    @mentoring_request.status = 'pending'
    if @mentoring_request.save
      flash[:notice] = "A request has been sent to #{@mentoring_request.receiver.email}"
      redirect_to requests_user_mentorship_index_path
    else
      flash[:alert] = @mentoring_request.errors.full_messages.first
      render 'user/mentorship/mentors/new'
    end
  end

  def update
    authorize current_user

    # we either add the user as a mentor or mentee
    @mentoring_request.status = 'accepted'
    if @mentoring_request.save
      if @mentoring_request.mentoring_type === 'mentor'
        Mentoring.create!(mentee_id: @mentoring_request.sender_id, mentor_id: @mentoring_request.receiver_id)
      else
        Mentoring.create!(mentor_id: @mentoring_request.sender_id, mentee_id: @mentoring_request.receiver_id)
      end

      flash[:notice] = 'Your request has been accepted'
      # we then destroy the request
      destroy
    else
      flash[:notice] = @mentoring_request.errors.full_messages.first
      redirect_to :back
    end
  end

  def destroy
    if @mentoring_request.status != 'accepted' && @mentoring_request.sender_id != current_user.id
      @mentoring_request.notify_declined_request
    elsif @mentoring_request.status === 'accepted'
      @mentoring_request.notify_accepted_request
    end
    @mentoring_request.destroy
    redirect_to :back
  end

  private

  def mentoring_request_params
    params.require(:mentoring_request).permit(:notes, :sender_id, :receiver_id, :mentoring_type)
  end

  def set_mentoring_request
    @mentoring_request = current_user.enterprise.mentoring_requests.find(params[:id])
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'new'
      'New Mentorship Request'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
