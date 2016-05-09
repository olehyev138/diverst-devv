class Groups::EventsController < ApplicationController
  before_action :set_group
  before_action :set_event, only: [:edit, :update, :destroy, :show, :export_ics]

  layout 'erg'

  def index
    @upcoming_events = @group.events.upcoming
    @past_events = @group.events.past
    @ongoing_events = @group.events.ongoing
  end

  def new
    @event = @group.events.new
  end

  def create
    @event = @group.events.new(event_params)

    if @event.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    @comment = @event.comments.where(user: current_user).first || EventComment.new(event: @event)
  end

  def update
    if @event.update(event_params)
      redirect_to [@group, @event]
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to action: :index
  end

  def export_ics
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = @event.start
      e.dtend       = @event.end
      e.summary     = @event.title
      e.description = @event.description
      e.ip_class    = "PRIVATE"
    end

    send_data cal.to_ical, filename: "#{@event.title.parameterize}.ics", disposition: 'attachment'
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_event
    @event = @group.events.find(params[:id])
  end

  def event_params
    params
      .require(:event)
      .permit(
        :title,
        :description,
        :start,
        :end,
        :location,
        :max_attendees,
        :picture,
        segment_ids: []
      )
  end
end
