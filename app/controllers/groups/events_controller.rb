class Groups::EventsController < ApplicationController
  include AccessControl

  before_action :authenticate_user!
  before_action :set_group
  before_action :set_event, only: [:edit, :update, :destroy, :show]

  layout 'erg'

  def index
    @upcoming_events = @group.events.upcoming
    @past_events = @group.events.past.page(0)
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
