class Groups::AttendancesController < ApplicationController
  before_action :set_group
  before_action :set_event
  before_action :set_attendance, only: [:create, :destroy]

  layout 'erg'

  def show
    @attendances = @event.initiative_users
  end

  def create
    return head(204) if @attendance
    @event.initiative_users.create(user: current_user)
    head 204
  end

  def destroy
    return head(204) if !@attendance
    @attendance.destroy
    head 204
  end

  def erg_graph
    erg_population = @event.own_group.enterprise.groups.map do |group|
      @event.attendees.joins(:user_groups).where('user_groups.group_id': group.id).count
    end

    render json: {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Number of attendees',
          data: erg_population
        }],
        categories: @event.own_group.enterprise.groups.map(&:name),
        xAxisTitle: 'ERG'
      },
      hasAggregation: false
    }
  end

  def segment_graph
    segment_population = @event.own_group.enterprise.segments.map do |segment|
      @event.attendees.joins(:users_segments).where('users_segments.segment_id': segment.id).count
    end

    render json: {
      type: 'bar',
      highcharts: {
        series: [{
          title: 'Number of attendees',
          data: segment_population
        }],
        categories: @event.group.enterprise.segments.map(&:name),
        xAxisTitle: 'Segment'
      },
      hasAggregation: false
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
end
