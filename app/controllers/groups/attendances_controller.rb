class Groups::AttendancesController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event
  before_action :set_attendance, only: [:create, :destroy]
  after_action :visit_page, only: [:show]

  layout 'erg'

  def show
    if GroupEventsPolicy.new(current_user, [@group]).view_event_attendees?
      @attendances = @event.attendees.active
    else
      @attendances = []
    end
  end

  def create
    return head(204) if @attendance

    unless @event.full?
      @event.initiative_users.create(user: current_user)
      user_rewarder('attend_event').add_points(@event)
      flash_reward "Now you have #{ current_user.credits } points"
      render 'partials/flash_messages.js'
    end
  end

  def destroy
    return head(204) if !@attendance

    @attendance.destroy
    user_rewarder('attend_event').remove_points(@event)
    head 204
  end

  def erg_graph
    groups = @event.owner_group.enterprise.groups

    values = groups.map do |group|
      { x: group.name, y: @event.attendees.joins(:user_groups).where('user_groups.group_id': group.id).count }
    end

    render json: {
      title: 'Number of attendees',
      type: 'bar',
      series: [{
                 key: "Attendees per #{ c_t(:erg) }",
                 values: values
               }]
    }
  end

  def segment_graph
    segments = @event.owner_group.enterprise.segments

    values = segments.map do |segment|
      { x: segment.name, y: @event.attendees.joins(:users_segments).where('users_segments.segment_id': segment.id).count }
    end

    render json: {
      title: 'Number of attendees',
      type: 'bar',
      series: [{
                 key: "Attendees per #{ c_t(:segment) }",
                 values: values
               }]
    }
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_event
    @event = @group.initiatives.find(params[:event_id])
  end

  def set_attendance
    @attendance = @event.initiative_users.where(user: current_user).first
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'show'
      "#{@event.to_label} Attendees"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
