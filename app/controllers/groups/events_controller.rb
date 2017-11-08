class Groups::EventsController < ApplicationController
  include HtmlSanitizingHelper

  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event, only: [:edit, :update, :destroy, :show, :export_ics]

  layout 'erg'

  def index
    if @group.active_members.include? current_user || policy(@group).erg_leader_permissions?
      #TODO Those events are never used!
      @upcoming_events = @group.initiatives.upcoming + @group.participating_initiatives.upcoming
      @past_events = @group.initiatives.past + @group.participating_initiatives.past
      @ongoing_events = @group.initiatives.ongoing + @group.participating_initiatives.ongoing
    else
      @upcoming_events = []
      @past_events = []
      @ongoing_events = []
    end
  end

  # MISSING TEMPLATE
  def calendar_data
    @events = @group.initiatives
    .ransack(
        initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
    )
    .result

    render 'shared/calendar/events', format: :json
  end

  def calendar_view
    @segments = current_user.enterprise.segments
    @q_form_submit_path = calendar_view_group_events_path
    @q = Initiative.ransack(params[:q])
    
    render 'calendar_view'
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
    authorize @event

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

    description = strip_tags @event.description

    cal.event do |e|
      e.dtstart     = @event.start
      e.dtend       = @event.end
      e.summary     = @event.title
      e.description = description
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
