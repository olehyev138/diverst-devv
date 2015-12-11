require 'yammer'

class Auth::YammerController < ApplicationController
  before_action :init_yammer_client

  def login
    redirect_to @yammer_client.webserver_authorization_url
  end

  def callback
    ap params
    ap @yammer_client.access_token_from_authorization_code(params[:code], { :redirect_uri => 'https://demo.volume7.io/auth/yammer/callack2'})
    head 200
  end

  def callback2
    ap params
  end

  private

  def init_yammer_client
    @yammer_client = Yammer::OAuth2Client.new(ENV["YAMMER_CLIENT_ID"], ENV["YAMMER_CLIENT_SECRET"])
  end
end
