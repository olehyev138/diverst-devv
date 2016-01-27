class Employee::EventsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_event, only: [:show]

  layout 'employee'

  def index
    @upcoming_events = current_employee.events.upcoming
    @past_events = current_employee.events.past.page(0)
  end

  protected

  def set_event
    @event = current_employee.events.find(params[:id])
  end
end
