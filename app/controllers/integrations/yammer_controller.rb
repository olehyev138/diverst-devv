class Integrations::YammerController < ApplicationController
  layout 'global_settings'

  def login
    redirect_to YammerClient.webserver_authorization_url
  end

  def callback
    if params[:code].nil?
      redirect_to integrations_path, alert: 'Yammer authentication failed'
    end

    response = YammerClient.access_token_from(authorization_code: params[:code])
    user_token = response['access_token']['token']

    yammer = YammerClient.new(user_token)
    yammer_user = yammer.current_user

    if yammer_user['verified_admin'] == 'true' || yammer_user['verified_admin'] == true
      current_user.enterprise.update(yammer_token: user_token)
      redirect_to integrations_path
    else
      redirect_to integrations_path, alert: 'This Yammer account is not a verified admin in its network'
    end
  end
end
