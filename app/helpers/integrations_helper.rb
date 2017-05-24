module IntegrationsHelper
  def events_calendar_iframe_code(enterprise)
    url = integrations_calendar_url(enterprise.iframe_calendar_token)

    "<iframe src='#{url}'></iframe>"
  end
end
