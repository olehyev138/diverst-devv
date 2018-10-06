class MentoringSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mentoring_session, only: [:show, :edit, :update, :destroy, :start, :join, :export_ics]

  layout "user", :except => [:start, :join]

  def new
    @mentoring_session = current_user.mentoring_sessions.new
    @mentoring_session.format = "Video"
    @mentoring_session.mentorship_sessions.new(:user_id => current_user.id)
    @mentoring_session.mentorship_sessions.new(:user_id => params[:user_id])
    
    render 'user/mentorship/sessions/new'
  end

  def edit
    render 'user/mentorship/sessions/edit'
  end

  def show
    render 'user/mentorship/sessions/show'
  end

  def create
    @mentoring_session = current_user.enterprise.mentoring_sessions.new(mentoring_session_params)
    @mentoring_session.status = "scheduled"
    @mentoring_session.enterprise_id = current_user.enterprise_id
    @mentoring_session.creator_id = current_user.id

    if @mentoring_session.save
      redirect_to sessions_user_mentorship_index_path
    else
      flash[:alert] = "Your session was not scheduled"
      render 'user/mentorship/sessions/new'
    end
  end

  def update
    if @mentoring_session.update(mentoring_session_params)
      redirect_to @mentoring_session
    else
      redirect_to action: :edit
    end
  end

  def destroy
    @mentoring_session.destroy
    redirect_to sessions_user_mentorship_index_path
  end

  def start
    # check if user can start the session
    require 'twilio-ruby'
    
    raise BadRequestException.new "TWILIO_ACCOUNT_SID Required" if ENV["TWILIO_ACCOUNT_SID"].blank?
    raise BadRequestException.new "TWILIO_API_KEY Required" if ENV["TWILIO_API_KEY"].blank?
    raise BadRequestException.new "TWILIO_SECRET Required" if ENV["TWILIO_SECRET"].blank?
    
    account_sid = ENV["TWILIO_ACCOUNT_SID"]
    api_key_sid = ENV["TWILIO_API_KEY"]
    api_key_secret = ENV["TWILIO_SECRET"]

    # Create an Access Token
    token = Twilio::JWT::AccessToken.new(
      account_sid,
      api_key_sid,
      api_key_secret,
      identity: current_user.email
    )

    # Grant access to Video
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = @mentoring_session.video_room_name
    token.add_grant grant

    # Serialize the token as a JWT
    @token = token.to_jwt

    @mentoring_session.access_token = @token
    @mentoring_session.save!

    render 'user/mentorship/sessions/start'
  end

  def join
    # check if user has access to the session
    require 'twilio-ruby'

    account_sid = ENV["TWILIO_ACCOUNT_SID"]
    api_key_sid = ENV["TWILIO_API_KEY"]
    api_key_secret = ENV["TWILIO_SECRET"]

    # Create an Access Token
    token = Twilio::JWT::AccessToken.new(
      account_sid,
      api_key_sid,
      api_key_secret,
      identity: current_user.email
    )

    # Grant access to Video
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = @mentoring_session.video_room_name
    token.add_grant grant

    # Serialize the token as a JWT
    @token = token.to_jwt
    render 'user/mentorship/sessions/start'
  end
  
  def export_ics
    cal = Icalendar::Calendar.new
    cal.timezone do |t|
      t.tzid = current_user.default_time_zone
    end

    description = @mentoring_session.notes

    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new @mentoring_session.start, 'tzid' => current_user.default_time_zone
      e.dtend       = Icalendar::Values::DateTime.new @mentoring_session.end, 'tzid' => current_user.default_time_zone
      e.summary     = "Mentoring Session"
      #e.location    = @event.location
      e.description = description
      e.ip_class    = "PRIVATE"
    end

    send_data cal.to_ical, filename: "mentoring_session.ics", disposition: 'attachment'
  end

  private

  def mentoring_session_params
    params.require(:mentoring_session).permit(
      :notes,
      :start,
      :end,
      :format,
      mentoring_interest_ids: [],
      resources_attributes: [
        :id,
        :title,
        :file,
        :url,
        :_destroy
      ],
      mentorship_sessions_attributes: [
        :id,
        :user_id,
        :role,
        :attending,
        :_destroy
      ]
    )
  end

  def set_mentoring_session
    @mentoring_session = current_user.mentoring_sessions.find(params[:id])
  end

end