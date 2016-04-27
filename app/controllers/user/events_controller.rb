class User::EventsController < ApplicationController
  before_action :set_event, only: [:show]

  layout 'user'

  def index
    @upcoming_events = current_user.events.upcoming + current_user.invited_events.upcoming
    @past_events = current_user.events.past + current_user.invited_events.past
    @ongoing_events = current_user.events.ongoing + current_user.invited_events.ongoing
  end

  protected

  def set_event
    @event = current_user.events.find(params[:id])
  end
end
