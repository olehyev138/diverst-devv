class User::EventsController < ApplicationController
  before_action :set_event, only: [:show]

  layout 'user'

  def index
    @upcoming_events = current_user.initiatives.upcoming + current_user.invited_initiatives.upcoming
    @past_events =  current_user.initiatives.past + current_user.invited_initiatives.past
    @ongoing_events = current_user.initiatives.ongoing + current_user.invited_initiatives.ongoing
  end

  def calendar
  end

  def calendar_data
    own_events = current_user.initiatives.where('start >= ?', params[:start])
                                          .where('start <= ?', params[:end])

    invited_events = current_user.invited_initiatives.where('start >= ?', params[:start])
                                                      .where('start <= ?', params[:end])

    @events = own_events + invited_events

    render 'shared/calendar_events', format: :json
  end

  #Return calendar data for onboarding screen
  #No current user, use token for authentication
  def onboarding_calendar_data
    user = User.find_by_invitation_token(params[:invitation_token], true)

    @events = user.enterprise.initiatives.where('start >= ?', params[:start])
                                    .where('start <= ?', params[:end])

    render 'shared/calendar_events', format: :json
  end

  protected

  def set_event
    @event = current_user.initiatives.find(params[:id])
  end
end
