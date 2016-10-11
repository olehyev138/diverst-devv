class User::EventsController < ApplicationController
  before_action :set_event, only: [:show]

  layout 'user'

  def index
    @upcoming_events = current_user.events.upcoming + current_user.invited_events.upcoming
    @past_events = current_user.events.past + current_user.invited_events.past
    @ongoing_events = current_user.events.ongoing + current_user.invited_events.ongoing
  end

  def calendar
  end

  def calendar_data
    own_events = current_user.events.where('start >= ?', params[:start])
                                    .where('start <= ?', params[:end])

    invited_events = current_user.invited_events.where('start >= ?', params[:start])
                                    .where('start <= ?', params[:end])

    @events = own_events + invited_events

    render 'shared/calendar_events', format: :json
  end

  #Return calendar data for onboarding screen
  #No current user, use token for authentication
  def onboarding_calendar_data
    user = User.find_by_invitation_token(params[:invitation_token], true)

    @events = user.enterprise.events.where('start >= ?', params[:start])
                                    .where('start <= ?', params[:end])

    @branding_color = user.enterprise.theme.branding_color
    render 'shared/calendar_events', format: :json
  end

  protected

  def set_event
    @event = current_user.events.find(params[:id])
  end
end
