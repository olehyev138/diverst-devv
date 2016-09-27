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

    events = own_events + invited_events

    render json: events.map{ |e| e.as_json(only:[:id, :title, :start, :end]) }
  end

  protected

  def set_event
    @event = current_user.events.find(params[:id])
  end
end
