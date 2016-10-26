class Groups::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event, only: [:edit, :update, :destroy, :show, :export_ics]

  layout 'erg'

  def index
    @upcoming_events = @group.own_initiatives.upcoming
    @past_events = @group.own_initiatives.past
    @ongoing_events = @group.own_initiatives.ongoing

    #TODO - also show participating events?
  end

  def calendar_data
    @events = @group.own_initiatives.includes(:owner_group)
                          .where('start >= ?', params[:start])
                          .where('start <= ?', params[:end])

    #Todo also show participating events

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
    @event = @group.own_initiatives.find(params[:id])
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
