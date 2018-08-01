class User::MentorshipController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
    
    layout 'user'

    def index
    end
    
    # allow user to edit mentorship
    def edit
    end
    
    # allow users to view profiles for other users
    def show
    end
    
    def update
        authorize @user
        
        @user.assign_attributes(user_params)
        if @user.save
            flash[:notice] = "Your user was updated"
            # we redirect to mentors so the user can find a mentor
            redirect_to action: :mentors
        else
            flash[:alert] = "Your user was not updated. Please fix the errors"
            redirect_to :back
        end
    end
    
    def mentors
        @mentors = @user.mentors
    end
    
    def mentees
        @mentees = @user.mentees
    end
    
    def requests
        @mentorship_requests  =  @user.mentorship_requests
        @mentorship_proposals =  @user.mentorship_proposals
    end
    
    def sessions
        @sessions = @user.mentoring_sessions.upcoming
    end
    
    def ratings
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
            mentoring_interest_ids: [],
            mentoring_type_ids: []
        )
    end
end
