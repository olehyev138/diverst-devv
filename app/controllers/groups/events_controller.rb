class Groups::EventsController < ApplicationController
  include HtmlSanitizingHelper
  include OutlookAuthHelper

  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event, only: [:edit, :update, :destroy, :show, :export_ics]
  after_action :visit_page, only: [:index, :show]

  layout 'erg'

  def index
    if GroupPolicy.new(current_user, @group).is_an_accepted_member? || GroupPolicy.new(current_user, @group).manage?
      # TODO Those events are never used!
      @upcoming_events = @group.initiatives.upcoming + @group.participating_initiatives.upcoming
      @past_events = @group.initiatives.past + @group.participating_initiatives.past
      @ongoing_events = @group.initiatives.ongoing + @group.participating_initiatives.ongoing
    else
      @upcoming_events = @group.initiatives.upcoming + @group.participating_initiatives.upcoming
      @past_events = @group.initiatives.past + @group.participating_initiatives.past
      @ongoing_events = @group.initiatives.ongoing + @group.participating_initiatives.ongoing
    end
  end

  def calendar_data
    @events = @group.initiatives
    .ransack(
      initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
    )
    .result

    @events += @group.participating_initiatives.upcoming.ransack(
      initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
    )
    .result

    @events += @group.participating_initiatives.ongoing .ransack(
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

  def show
    authorize @event

    @participation = current_user.initiative_users.find_by(:initiative_id => @event.id)
    @has_outlook = has_outlook
    @all_comments = @event.comments
    @approved_comments = @event.comments.approved
    @comment = InitiativeComment.new(initiative: @event)
  end

  def destroy
    @event.destroy
    redirect_to action: :index
  end

  def export_ics
    cal = Icalendar::Calendar.new
    cal.timezone do |t|
      t.tzid = current_user.default_time_zone
    end

    description = strip_tags @event.description

    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new @event.start, 'tzid' => current_user.default_time_zone
      e.dtend       = Icalendar::Values::DateTime.new @event.end, 'tzid' => current_user.default_time_zone
      e.summary     = @event.title
      e.location    = @event.location
      e.description = description
      e.ip_class    = 'PRIVATE'
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Events"
    when 'show'
      "#{@event.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
