class Integrations::YammerController < ApplicationController
  before_action :authenticate_admin!

  layout 'global_settings'

  def login
    redirect_to YammerClient.webserver_authorization_url
  end

  def callback
    response = YammerClient.access_token_from(authorization_code: params[:code])
    current_admin.enterprise.update(yammer_token: response["access_token"]["token"])
    redirect_to enterprise_integrations_path(current_admin.enterprise)
  end
end
