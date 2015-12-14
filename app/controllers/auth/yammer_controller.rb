require 'yammer'

class Auth::YammerController < ApplicationController
  before_action :init_yammer_client
  before_action :authenticate_admin!

  def login
    redirect_to @yammer_client.webserver_authorization_url
  end

  def callback
    response = JSON.parse @yammer_client.access_token_from_authorization_code(params[:code], { redirect_uri: "http://#{ENV["DOMAIN"]}/auth/yammer/callback"}).body
    current_admin.enterprise.update(yammer_token: response["access_token"]["token"])
    redirect_to enterprise_integrations_path(current_admin.enterprise)
  end

  private

  def init_yammer_client
    @yammer_client = Yammer::OAuth2Client.new(ENV["YAMMER_CLIENT_ID"], ENV["YAMMER_CLIENT_SECRET"])
  end
end
