class InitiativesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_initiative, only: [:edit, :update, :destroy, :show, :todo, :finish_expenses, :export_attendees_csv, :archive, :start_video, :join_video, :leave_video, :register_room_in_database, :update_registered_room_in_database]
  before_action :set_segments, only: [:new, :create, :edit, :update]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :show, :edit, :todo]

  layout 'erg'

  def index
    authorize [@group], :index?, policy_class: GroupEventsPolicy
    @outcomes = @group.outcomes.includes(:pillars)

    set_filter
  end

  def new
    authorize [@group], :new?, policy_class: GroupEventsPolicy
    @initiative = Initiative.new
  end

  def create
    authorize [@group], :create?, policy_class: GroupEventsPolicy
    @initiative = Initiative.new(initiative_params)
    @initiative.owner = current_user
    @initiative.owner_group = @group
    # bTODO add event to @group.own_initiatives

    annual_budget = current_user.enterprise.annual_budgets.find_or_create_by(closed: false, group_id: @group.id)
    @initiative.annual_budget_id = annual_budget.id

    if @initiative.save
      flash[:notice] = 'Your event was created'
      track_activity(@initiative, :create)
      redirect_to action: :index
    else
      flash[:alert] = 'Your event was not created. Please fix the errors'
      render :new
    end
  end

  def show
    authorize [@group, @initiative], :show?, policy_class: GroupEventsPolicy
    @updates = @initiative.updates.order(created_at: :desc).limit(3).reverse # Shows the last 3 updates in chronological order
  end

  def edit
    authorize [@group, @initiative], :edit?, policy_class: GroupEventsPolicy
  end

  def update
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy

    AnnualBudgetManager.new(@group).re_assign_annual_budget(initiative_params['budget_item_id'], @initiative.id)

    if @initiative.update(initiative_params)
      flash[:notice] = 'Your event was updated'
      track_activity(@initiative, :update)
      redirect_to [@group, :initiatives]
    else
      flash[:alert] = 'Your event was not updated. Please fix the errors'
      render :edit
    end
  end

  def finish_expenses
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy

    # skip before_save :allocate_budget_funds because
    # finish_expenses primary responsibility is to close off
    # expenses and not to allocate_budget_funds
    @initiative.skip_allocate_budget_funds = true
    @initiative.finish_expenses!
    redirect_to action: :index
  end

  def destroy
    authorize [@group, @initiative], :destroy?, policy_class: GroupEventsPolicy

    track_activity(@initiative, :destroy)
    if @initiative.destroy
      flash[:notice] = 'Your event was deleted'
      redirect_to action: :index
    else
      flash[:alert] = 'Your event was not deleted. Please fix the errors'
      redirect_to :back
    end
  end

  def todo
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy
  end

  def export_attendees_csv
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy

    EventAttendeeDownloadJob.perform_later(current_user.id, @initiative)
    track_activity(@initiative, :export_attendees)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  def export_csv
    authorize [@group], :index?, policy_class: GroupEventsPolicy
    @outcomes = @group.outcomes.includes(pillars: { initiatives: :fields })

    set_filter

    # Gets and filters the initiatives from outcomes on date
    initiative_ids = Outcome.get_initiatives(@outcomes).select { |i| i.start >= @filter_from && i.start <= @filter_to }.map { |i| i.id }

    InitiativesDownloadJob.perform_later(current_user.id, @group.id, initiative_ids)
    track_activity(@group, :export_initiatives)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  def archive
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy

    @initiative.skip_allocate_budget_funds = true
    @initiatives = @group.initiatives.where(archived_at: nil).all
    @initiative.update(archived_at: DateTime.now)
    track_activity(@initiative, :archive)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def start_video
    # Only user with permission to update group should be able to start a call
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy

    # check if user can start the session
    require 'twilio-ruby'

    raise BadRequestException.new 'TWILIO_ACCOUNT_SID Required' if ENV['TWILIO_ACCOUNT_SID'].blank?
    raise BadRequestException.new 'TWILIO_API_KEY Required' if ENV['TWILIO_API_KEY'].blank?
    raise BadRequestException.new 'TWILIO_SECRET Required' if ENV['TWILIO_SECRET'].blank?

    account_sid = ENV['TWILIO_ACCOUNT_SID']
    api_key_sid = ENV['TWILIO_API_KEY']
    api_key_secret = ENV['TWILIO_SECRET']

    @video_room_name = "#{request.domain}Initiative#{@initiative.id}"
    @enterprise = @group.enterprise
    # Create an Access Token
    token = Twilio::JWT::AccessToken.new(
      account_sid,
      api_key_sid,
      api_key_secret,
      identity: current_user.email
    )

    # Grant access to Video
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = @video_room_name
    token.add_grant grant

    # Serialize the token as a JWT
    @token = token.to_jwt

    track_activity(@initiative, :start_video)
  end

  def leave_video
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy
    track_activity(@initiative, :leave_video)
    render nothing: true
  end

  def enable_virtual_meet
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy
    @initiative.virtual_toggle
    render nothing: true
  end

  def register_room_in_database
    # need to skip authorization here because it is redundant? you are already in the room and data
    # needs to be collected.
    authorize [@group, @initiative], :update?, policy_class: GroupEventsPolicy

    sid = params[:sid]
    name = params[:name]
    status = params[:status]
    group = Group.find(params[:group_id])
    enterprise_id = group.enterprise_id

    room = VideoRoom.new(
      sid: sid,
      name: name,
      status: status,
      enterprise_id: enterprise_id,
      initiative_id: @initiative.id
    )

    if room.save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def update_registered_room_in_database
    require 'twilio-ruby'

    raise BadRequestException.new 'TWILIO_ACCOUNT_SID Required' if ENV['TWILIO_ACCOUNT_SID'].blank?
    raise BadRequestException.new 'TWILIO_AUTH_TOKEN Required' if ENV['TWILIO_AUTH_TOKEN'].blank?

    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    sid = params[:sid]
    room_context = client.video.rooms(sid)
    room = client.video.rooms(sid).fetch
    video_room = VideoRoom.find_by(sid: sid)

    if video_room && video_room.update(
      status: room.status,
      duration: room.duration,
      participants: room_context.participants.list.count,
      start_date: room.date_created,
      end_date: room.end_time
    )
      render noting: true, status: :ok
    else
      render nothing: true, status: :unprocessable_entity
    end
  end


  protected

  def set_filter
    @initiative = Initiative.new

    if params[:initiative].present?
      @initiative.from = Date.parse(initiative_params[:from]).beginning_of_day
      @initiative.to = Date.parse(initiative_params[:to]).end_of_day
    else
      @initiative.from = 1.year.ago.beginning_of_day
      @initiative.to = 1.month.from_now.end_of_day
    end

    @filter_from = @initiative.from
    @filter_to = @initiative.to
  end

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_initiative
    @initiative = @group.initiatives.find(params[:id])
  end

  def set_segments
    @segments = current_user.enterprise.segments
  end

  def initiative_params
    params
      .require(:initiative)
      .permit(
        :name,
        :description,
        :start,
        :end,
        :max_attendees,
        :pillar_id,
        :location,
        :picture,
        :video,
        :budget_item_id,
        :estimated_funding,
        :archived_at,
        :from, # For filtering
        :to, # For filtering
        :annual_budget_id,
        :virtual,
        participating_group_ids: [],
        segment_ids: [],
        fields_attributes: [
          :id,
          :title,
          :_destroy,
          :gamification_value,
          :show_on_vcard,
          :saml_attribute,
          :type,
          :min,
          :max,
          :options_text,
          :alternative_layout
        ],
        checklist_items_attributes: [
          :id,
          :title,
          :is_done,
          :_destroy
        ],
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.to_label}'s Initiative"
    when 'new'
      "#{@group.to_label} Initiative Creation"
    when 'show'
      "Event: #{@initiative.to_label}"
    when 'edit'
      "Initiative Edit: #{@initiative.to_label}"
    when 'todo'
      "Initiative Todo: #{@initiative.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
