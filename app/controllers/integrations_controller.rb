class IntegrationsController < ApplicationController
  before_action :set_enterprise_from_token, only: [:calendar]

  layout :resolve_layout

  def calendar
    @groups = @enterprise.groups
    @segments = @enterprise.segments
    @q_form_submit_path = integrations_calendar_path(params[:token])
    @q = Initiative.ransack(params[:q])

    render 'shared/calendar/calendar_view'
  end

  private

  def resolve_layout
    case action_name
    when 'calendar'
      'iframe'
    end
  end

  def set_enterprise_from_token
    token = params[:token]
    not_found! if token.nil? || token.empty?

    @enterprise = Enterprise.find_by_iframe_calendar_token(token)

    not_found! if @enterprise.nil?
  end
end
