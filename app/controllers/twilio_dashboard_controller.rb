class TwilioDashboardController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_enterprise
  before_action :set_video_room, only: [:show]
  require 'twilio-ruby'

  layout 'global_settings'

  def index
    authorize User

    @rooms = VideoRoom.where(enterprise_id: @enterprise.id).all

    respond_to do |format|
      format.html
      format.json { render json: TwilioUsageDatatable.new(view_context, @rooms) }
    end
  end

  def show
    authorize User

    raise BadRequestException.new 'TWILIO_ACCOUNT_SID Required' if ENV['TWILIO_ACCOUNT_SID'].blank?
    raise BadRequestException.new 'TWILIO_AUTH_TOKEN Required' if ENV['TWILIO_AUTH_TOKEN'].blank?

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    @participants = @video_room.video_participants
  end

  private

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_video_room
    @video_room = VideoRoom.find(params[:id])
  end
end
