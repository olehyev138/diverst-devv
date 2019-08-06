class ClockworkDatabaseEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_clockwork_database_event, only: [:edit, :update, :show]

  layout 'global_settings'

  def index
    authorize current_user.enterprise, :enterprise_manage?
    visit_page('Clockwork Events')
    @enterprise = current_user.enterprise
    @clockwork_database_events = @enterprise.clockwork_database_events
  end

  def edit
    authorize current_user.enterprise, :enterprise_manage?
    visit_page('Clockwork Events')
  end

  def update
    authorize current_user.enterprise, :enterprise_manage?
    if @clockwork_database_event.update(clockwork_database_event_params)
      flash[:notice] = 'Your email event was updated'
      track_activity(@clockwork_database_event, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your email event was not updated. Please fix the errors'
      render :edit
    end
  end

  protected

  def set_clockwork_database_event
    @clockwork_database_event = current_user.enterprise.clockwork_database_events.find(params[:id])
  end

  def clockwork_database_event_params
    params
      .require(:clockwork_database_event)
      .permit(
        :name,
        :frequency_quantity,
        :frequency_period_id,
        :disabled,
        :day,
        :at,
        :tz
      )
  end
end
