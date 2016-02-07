class User::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show]

  layout 'user'

  def index
    @upcoming_events = current_user.events.upcoming
    @past_events = current_user.events.past.page(0)
  end

  protected

  def set_event
    @event = current_user.events.find(params[:id])
  end
end
