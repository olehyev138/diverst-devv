class Groups::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event, only: [:edit, :update, :destroy, :show, :export_ics]

  layout 'erg'

  def index
    #TODO Those events are never used!
    @upcoming_events = @group.initiatives.upcoming + @group.participating_initiatives.upcoming
    @past_events = @group.initiatives.past + @group.participating_initiatives.past
    @ongoing_events = @group.initiatives.ongoing + @group.participating_initiatives.ongoing
  end

  def calendar_data
    own_events = @group.initiatives
                          .of_segments(current_user.segments.pluck(:id))
                          .includes(:owner_group)
                          .where('start >= ?', params[:start])
                          .where('start <= ?', params[:end])

    participating_events = @group.participating_initiatives
                              .of_segments(current_user.segments.pluck(:id))
                              .includes(:owner_group)
                              .where('start >= ?', params[:start])
                              .where('start <= ?', params[:end])

    @events = own_events + participating_events

    render 'shared/calendar_events', format: :json
  end

  def calendar_view
  end

  # def new
  #   @event = @group.own_initiatives.new
  # end

  # def create
  #   @event = @group.own_initiatives.new(event_params)

  #   if @event.save
  #     redirect_to action: :index
  #   else
  #     render :edit
  #   end
  # end

  def show
    authorize @event, :show_calendar?

    @comment = @event.comments.where(user: current_user).first || InitiativeComment.new(initiative: @event)
  end

  # def update
  #   if @event.update(event_params)
  #     redirect_to [@group, @event]
  #   else
  #     render :edit
  #   end
  # end

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
    @event = @group.initiatives.find(params[:id])
  end

  def event_params
    params
      .require(:event)
      .permit(
        :name,
        :description,
        :start,
        :end,
        :location,
        :max_attendees,
        :picture,
        :attendee_ids,
        segment_ids: [],
        fields_attributes: [
          :id,
          :title,
          :_destroy,
          :gamification_value,
          :show_on_vcard,
          :saml_attribute,
          :type,
          :match_exclude,
          :match_weight,
          :match_polarity,
          :min,
          :max,
          :options_text,
          :alternative_layout
        ]
      )
  end
end
