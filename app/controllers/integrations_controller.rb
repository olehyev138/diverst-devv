class IntegrationsController < ApplicationController
  before_action :set_enterprise_from_token, only: [:calendar]
  after_action :visit_page, only: [:calendar]

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
    else
      'global_settings'
    end
  end

  def set_enterprise_from_token
    token = params[:token]
    not_found! if token.blank?

    @enterprise = Enterprise.find_by_iframe_calendar_token(token)

    not_found! if @enterprise.nil?
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'calendar'
      'Integrations Calender'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
