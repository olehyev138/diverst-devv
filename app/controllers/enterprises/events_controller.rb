class Enterprises::EventsController < ApplicationController
  before_action :set_enterprise, only: [:public_calendar_data]

  def public_calendar_data
    @events = @enterprise.initiatives
    render 'shared/calendar/events', format: :json
  end

  private

  def set_enterprise
    @enterprise = Enterprise.find(params[:enterprise_id])
  end
end
