class IntegrationsController < ApplicationController

  layout :resolve_layout

  def calendar
    @enterprise = Enterprise.find 1
    @groups = @enterprise.groups
    @segments = @enterprise.segments
    @q_form_submit_path = integrations_calendar_path
    @q = Initiative.ransack(params[:q])

    render 'shared/calendar/calendar_view'
  end

  private

  def resolve_layout
    case action_name
    when 'calendar'
      'iframe'
    else
      'global_settings'
    end
  end
end
