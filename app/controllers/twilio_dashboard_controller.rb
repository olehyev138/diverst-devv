class TwilioDashboardController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_enterprise

  layout 'global_settings'

  def index
    authorize User
    
    account_sid = "AC96e9f809a29495d4acc1431d8171d310"
    auth_token = "4717433627706502339e922f5b2134a3"
    
    client = Twilio::REST::Client.new(account_sid, auth_token)
    @rooms = client.video.rooms.list(status: 'completed') + client.video.rooms.list(status: 'in-progress')
  end

  private

  def set_enterprise
    @enterprise = current_user.enterprise
  end
end
