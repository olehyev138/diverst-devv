class User::MentorshipController < ApplicationController
  before_action   :authenticate_user!
  before_action   :set_user

  layout 'user'

  def index
    visit_page('Mentorship Home Page')
  end

  # allow user to edit mentorship
  def edit
    authorize @user, :edit?
    visit_page('Edit Personal Mentorship Setting')
  end

  # allow users to view profiles for other users
  def show
    visit_page("#{@user.name}'s Mentorship Settings")
  end

  def update
    authorize @user

    @user.assign_attributes(user_params)
    if @user.save
      track_activity(@user, :update_mentorship_profile)
      flash[:notice] = 'Your user was updated'
      # we redirect to mentors so the user can find a mentor only if mentor and mentee are true
      if @user.mentor? || @user.mentee?
        redirect_to action: :mentors
      else
        redirect_to action: :edit
      end
    else
      flash[:alert] = 'Your user was not updated. Please fix the errors'
      redirect_to :back
    end
  end

  def mentors
    visit_page('Mentor List')
    @mentorings = @user.menteeships
  end

  def mentees
    visit_page('Mentee List')
    @mentorings = @user.mentorships
  end

  def requests
    visit_page('Mentorship Request')
    @mentorship_proposals = @user.mentorship_proposals.mentor_requests
    @menteeship_proposals = @user.mentorship_proposals.mentee_requests

    @mentorship_requests = @user.accepting_mentor_requests ? @user.mentorship_requests.mentor_requests : []
    @menteeship_requests = @user.accepting_mentee_requests ? @user.mentorship_requests.mentee_requests : []
  end

  def sessions
    visit_page('Mentorship Sessions')
    @sessions = @user.mentoring_sessions.upcoming.select do |session|
      MentoringSessionPolicy.new(current_user, session).show?
    end
  end

  def ratings
    visit_page('Mentorship Feedback List')
    @sessions = @user.mentoring_sessions.past.no_ratings
    @ratings = @user.mentorship_ratings
  end

  protected

  def set_user
    @user = User.find_by_id(params[:id]) || current_user
  end

  def user_params
    params.require(:user).permit(
      :mentor,
      :mentee,
      :mentorship_description,
      :time_zone,
      :accepting_mentor_requests,
      :accepting_mentee_requests,
      mentoring_interest_ids: [],
      mentoring_type_ids: [],
      availabilities_attributes: [:day, :start, :end, :_destroy, :id]
    )
  end
end
