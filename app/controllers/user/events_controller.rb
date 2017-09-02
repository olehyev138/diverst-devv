class User::EventsController < ApplicationController
  before_action :set_event, only: [:show]

  layout 'user'

  def index
    @upcoming_events = current_user.initiatives.upcoming + current_user.invited_initiatives.upcoming
    @past_events =  current_user.initiatives.past + current_user.invited_initiatives.past
    @ongoing_events = current_user.initiatives.ongoing + current_user.invited_initiatives.ongoing
  end

  def calendar
    enterprise = current_user.enterprise
    @groups = enterprise.groups
    @segments = enterprise.segments
    @q_form_submit_path = calendar_user_events_path
    @q = Initiative.ransack(params[:q])

    render 'shared/calendar/calendar_view'
  end

  #Return calendar data for onboarding screen
  #No current user, use token for authentication
  def onboarding_calendar_data
    user = User.find_by_invitation_token(params[:invitation_token], true)
    @events = user.enterprise.initiatives.where('start >= ?', params[:start])
                                    .where('start <= ?', params[:end])

    render 'shared/calendar/events', format: :json
  end

  protected

  def set_event
    @event = current_user.initiatives.find(params[:id])
  end
end
