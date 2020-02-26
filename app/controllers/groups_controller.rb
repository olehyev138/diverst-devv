class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:calendar_data]
  before_action :set_group, except: [:index, :new, :create, :calendar, :calendar_data, :close_budgets, :close_budgets_export_csv, :sort, :get_all_groups, :get_paginated_groups]
  before_action :set_groups, only: [:index, :get_all_groups]
  skip_before_action :verify_authenticity_token, only: [:create, :calendar_data]
  after_action :verify_authorized, except: [:calendar_data]
  after_action :visit_page, only: [:index, :close_budgets, :calender, :new, :show, :edit, :layouts,
                                   :settings, :plan_overview, :metrics, :import_csv, :edit_fields]

  layout :resolve_layout

  helper ApplicationHelper

  def index
    authorize Group

    @groups = @groups.includes(:children)

    respond_to do |format|
      format.html
      format.json { render json: GroupDatatable.new(view_context, @groups) }
    end
  end

  def get_paginated_groups
    authorize Group, :index?

    respond_to do |format|
      format.json {
        groups = current_user.enterprise.groups.all_parents
                   .order(:position)
                   .joins('LEFT JOIN groups as children ON groups.id = children.parent_id')
                   .uniq
                   .where('LOWER(groups.name) like ? OR LOWER(children.name) like ?', "%#{search_params[:term]}%", "%#{search_params[:term]}%")
                   .page(search_params[:page])
                   .per(search_params[:limit])
                   .includes(:children)

        groups_hash = groups.as_json(
          only: [:id, :name, :parent_id, :position],
          include: {
            children: {
              only: [:id, :name, :parent_id, :position],
              methods: :logo_expiring_thumb
            }
          },
          methods: :logo_expiring_thumb
        )

        render json: {
          total_pages: groups.total_pages,
          group_text: c_t(:erg),
          group_text_pluralized: c_t(:erg).pluralize,
          groups: groups_hash
        }
      }
    end
  end

  def get_all_groups
    authorize Group, :index?

    respond_to do |format|
      format.json {
        @groups = @groups
                    .where('name like ?', "%#{search_params[:term]}%")
                    .where(id: [search_params[:ids]]) unless search_params[:ids].nil?

        render json: @groups
                       .map { |g| { id: g.id, text: g.name } }
                       .as_json
      }
    end
  end

  def close_budgets
    authorize Group, :manage_all_group_budgets?
    @groups = policy_scope(Group).includes(:children).all_parents
  end

  def close_budgets_export_csv
    authorize Group, :manage_all_group_budgets?
    GroupsCloseBudgetsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
    track_activity(current_user.enterprise, :export_close_budgets)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  # calendar for all of the groups
  def calendar
    authorize Group
    enterprise = current_user.enterprise
    @groups = []
    enterprise.groups.each do |group|
      if group.is_parent_group?
        @groups << group
        group.children.each do |sub_group|
          @groups << sub_group
        end
      elsif group.is_standard_group?
        @groups << group
      end
    end
    @segments = enterprise.segments
    @q_form_submit_path = calendar_groups_path
    @q = Initiative.ransack(params[:q])

    render 'shared/calendar/calendar_view'
  end

  # missing a template
  def calendar_data
    # To allow logged users see embedded calendars of other enterprises, we check for token first
    if params[:token]
      enterprise = Enterprise.find_by_iframe_calendar_token(params[:token])
    else
      enterprise = current_user&.enterprise
    end

    not_found! if enterprise.nil?

    # this is a hack to return all initiatives as it happens when you filter with no inputs
    params[:q] = { initiative_participating_groups_group_id_in: '', initiative_segments_segment_id_in: '' } if params[:q].nil?

    @events = enterprise.initiatives.includes(:initiative_participating_groups).where(groups: { parent_id: nil })
        .ransack(
          initiative_participating_groups_group_id_in: params[:q]&.dig(:initiative_participating_groups_group_id_in),
          outcome_group_id_in: params[:q]&.dig(:initiative_participating_groups_group_id_in),
          m: 'or'
        )
        .result
        .ransack(
          initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
        )
        .result

    @events += enterprise.initiatives.includes(:initiative_participating_groups).where.not(groups: { parent_id: nil })
        .ransack(
          initiative_participating_groups_group_id_in: Group.where(parent_id: params[:q]&.dig(:initiative_participating_groups_group_id_in)).pluck(:id),
          outcome_group_id_in: Group.where(parent_id: params[:q]&.dig(:initiative_participating_groups_group_id_in)).pluck(:id),
          m: 'or'
        )
        .result
        .ransack(
          initiative_segments_segment_id_in: params[:q]&.dig(:initiative_segments_segment_id_in)
        )
        .result

    render 'shared/calendar/events', formats: :json
  end

  def new
    authorize Group
    @group = current_user.enterprise.groups.new
    @categories = current_user.enterprise.group_categories
    # groups available to be parents or children
    @available_groups = @group.enterprise.groups.where.not(id: @group.id)
  end

  def show
    authorize @group
    @group_sponsors = @group.sponsors
    @show_events = should_show_event?(@group)

    if GroupPolicy.new(current_user, @group).manage?
      base_show

      @posts = without_segments
    else
      if GroupPolicy.new(current_user, @group).is_an_accepted_member?
        base_show
        @posts = with_segments
      else
        @upcoming_events = Initiative.all_upcoming_events_for_group(@group.id)
        @user_groups = []
        @messages = []
        @user_group = []
        @leaders = @group.group_leaders.includes(:user).visible
        @user_groups = []
        @top_user_group_participants = []
        @top_group_participants = []
        @posts = with_segments
      end
    end
  end

  def create
    authorize Group

    @group = current_user.enterprise.groups.new(group_params)
    @group.owner = current_user

    if group_params[:group_category_id].present?
      @group.group_category_type_id = GroupCategory.find_by(id: group_params[:group_category_id])&.group_category_type_id
    else
      @group.group_category_type_id = nil
    end

    if @group.save
      track_activity(@group, :create)
      flash[:notice] = "Your #{c_t(:erg)} was created"
      redirect_to groups_url
    else
      flash.now[:alert] = "Your #{c_t(:erg)} was not created. Please fix the errors"
      @categories = current_user.enterprise.group_categories
      render :new
    end
  end

  def edit
    authorize @group
    @categories = current_user.enterprise.group_categories
    # groups available to be parents or children
    @available_groups = @group.enterprise.groups.where.not(id: @group.id)
  end

  def update
    authorize @group
    update_group
  end

  def update_group
    if group_params[:group_category_id].present?
      @group.group_category_type_id = GroupCategory.find_by(id: group_params[:group_category_id])&.group_category_type_id
    end

    if @group.update(group_params)
      track_activity(@group, :update)
      flash[:notice] = "Your #{c_t(:erg)} was updated"

      redirect_to :back
    else
      flash.now[:alert] = "Your #{c_t(:erg)} was not updated. Please fix the errors"

      if request.referer == edit_group_url(@group) || request.referer == group_url(@group)
        @categories = current_user.enterprise.group_categories
        render :edit
      else
        render :settings
      end
    end
  end

  def update_questions
    authorize @group, :insights?
    update_group
  end

  def update_layouts
    authorize @group, :layouts?
    update_group
  end

  def update_settings
    authorize @group, :settings?
    update_group
  end

  def layouts
    authorize @group
  end

  def settings
    authorize @group
  end

  def plan_overview
    authorize [@group], :index?, policy_class: GroupBudgetPolicy
  end

  def destroy
    authorize @group

    track_activity(@group, :destroy)
    if @group.destroy
      flash[:notice] = "Your #{c_t(:erg)} was deleted"
      redirect_to action: :index
    else
      flash[:alert] = "Your #{c_t(:erg)} was not deleted. Please fix the errors"
      redirect_to :back
    end
  end

  def metrics
    authorize @group, :manage?
    @updates = @group.updates
  end

  def import_csv
    authorize @group, :edit?
  end

  def sample_csv
    authorize @group, :show?

    csv_string = CSV.generate do |csv|
      csv << ['Email']

      @group.members.limit(5).each do |user|
        csv << [user.email]
      end
    end

    send_data csv_string, filename: 'erg_import_example.csv'
  end

  def parse_csv
    authorize @group, :edit?

    if params[:file].nil?
      flash[:alert] = 'CSV file is required'
      redirect_to :back
      return
    end

    file = CsvFile.new(import_file: params[:file].tempfile, user: current_user, group_id: @group.id)

    @message = ''
    @success = false
    @email = ENV['CSV_UPLOAD_REPORT_EMAIL']

    if file.save
      track_activity(@group, :import_csv)
      @success = true
      @message = '@success'
    else
      @success = false
      @message = 'error'
      @errors = file.errors.full_messages
    end
  end

  def export_csv
    authorize @group, :show?
    GroupMemberDownloadJob.perform_later(current_user.id, @group.id)
    track_activity(@group, :export_members)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  def edit_fields
    authorize @group, :edit?
  end

  def delete_attachment
    authorize @group, :update?

    @group.banner = nil
    if @group.save
      flash[:notice] = 'Group attachment was removed'
      redirect_to :back
    else
      flash[:alert] = 'Group attachment was not removed. Please fix the errors'
      redirect_to :back
    end
  end

  def sort
    authorize Group
    params[:group].each_with_index do |id, index|
      current_user.enterprise.groups.find(id).update(position: index + 1)
    end
    render nothing: true
  end

  def auto_archive_switch
    authorize @group, :settings?
    @group.archive_switch
    render nothing: true
  end

  def slack_button_redirect
    authorize @group, :settings?
    client = Slack::Web::Client.new

    if params[:code].blank?
      flash[:alert] = 'You did not grant permission. Diverst was not added to slack'
    else
      # Request a token using the temporary code
      rc = client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        redirect_uri: slack_button_redirect_group_url(@group),
        code: params[:code]
      )

      # Pluck the token from the response
      @group.slack_webhook = RsaEncryption.encode(rc['incoming_webhook']['url'])
      @group.slack_auth_data = RsaEncryption.encode(rc.to_json)
      if @group.save
        flash[:notice] = 'Congratulations. We will send a slack notification when an event or post is created'
      else
        flash[:alert] = 'There was an error. Diverst was not added to slack'
      end
    end
    redirect_to @group
  end

  def slack_uninstall
    authorize @group, :settings?
    @group.uninstall_slack
    redirect_to :back
  end

  protected

  def should_show_event?(group)
    group.upcoming_events_visibility == 'public' ||
      group.upcoming_events_visibility == 'non_member' ||
      (group.upcoming_events_visibility == 'group' && current_user.is_member_of?(group)) ||
      (group.upcoming_events_visibility == 'leaders_only' && current_user.is_group_leader_of?(group))
  end

  def base_show
    @upcoming_events = Initiative.all_upcoming_events_for_group(@group.id)
    @messages = @group.messages.includes(:owner).limit(3)
    @user_group = @group.user_groups.find_by(user: current_user)
    @leaders = @group.group_leaders.includes(:user).visible

    @members = @group.active_members.order(created_at: :desc).limit(8)

    @top_user_group_participants = @group.user_groups.active.top_participants(10).includes(:user)
    @top_group_participants = @group.enterprise.groups.non_private.top_participants(10)
  end

  def without_segments
    @group.news_feed.all_links_without_segments
        .approved
        .active
        .include_posts(social_enabled: @group.enterprise.enable_social_media?)
        .order(is_pinned: :desc, created_at: :desc)
        .limit(5)
  end

  def with_segments
    if GroupPostsPolicy.new(current_user, [@group]).view_latest_news?
      segment_ids = current_user.segment_ids
      @group.news_feed.all_links(segment_ids)
          .approved
          .active
          .include_posts(social_enabled: @group.enterprise.enable_social_media?)
          .order(is_pinned: :desc, created_at: :desc)
          .limit(5)
    else
      []
    end
  end

  def resolve_layout
    case action_name
    when 'show', 'layouts', 'settings', 'plan_overview', 'metrics', 'edit_fields'
      'erg'
    when 'close_budgets'
      'plan'
    else
      'erg_manager'
    end
  end

  def set_group
    @group = current_user.enterprise.groups.find(params[:id])
  end

  def set_groups
    @groups = GroupPolicy::Scope.new(current_user, current_user.enterprise.groups, :groups_manage)
    .resolve.order(:position)
  end

  def search_params
    params.permit(:page, :limit, :term, ids: [])
  end

  def group_params
    params
        .require(:group)
        .permit(
          :name,
          :short_description,
          :description,
          :home_message,
          :logo,
          :private,
          :banner,
          :yammer_create_group,
          :yammer_sync_users,
          :yammer_group_link,
          :pending_users,
          :members_visibility,
          :messages_visibility,
          :event_attendance_visibility,
          :latest_news_visibility,
          :upcoming_events_visibility,
          :calendar_color,
          :active,
          :contact_email,
          :sponsor_image,
          :company_video_url,
          :layout,
          :parent_id,
          :group_category_id,
          :group_category_type_id,
          :position,
          :auto_archive,
          :expiry_age_for_news,
          :expiry_age_for_resources,
          :expiry_age_for_events,
          :unit_of_expiry_age,
          manager_ids: [],
          child_ids: [],
          member_ids: [],
          invitation_segment_ids: [],
          outcomes_attributes: [
              :id,
              :name,
              :_destroy,
              pillars_attributes: [
                  :id,
                  :name,
                  :value_proposition,
                  :_destroy
              ]
          ],
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
          survey_fields_attributes: [
              :id,
              :title,
              :_destroy,
              :show_on_vcard,
              :saml_attribute,
              :type,
              :min,
              :max,
              :options_text,
              :alternative_layout
          ],
          sponsors_attributes: [
            :id,
            :sponsor_name,
            :sponsor_title,
            :sponsor_message,
            :sponsor_media,
            :disable_sponsor_message,
            :_destroy
          ]
        )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{c_t(:erg)} List"
    when 'close_budgets'
      'Close Budgets'
    when 'calendar'
      "#{c_t(:erg).pluralize} Calender"
    when 'new'
      "#{c_t(:erg)} Creation"
    when 'show'
      "#{@group.to_label}'s Home"
    when 'edit'
      "#{c_t(:sub_erg)} Edit: #{@group.to_label}"
    when 'layouts'
      "#{@group.to_label}'s Layout Setting"
    when 'settings'
      "#{@group.to_label}'s Settings"
    when 'plan_overview'
      "#{@group.to_label}'s Plan Overview"
    when 'metrics'
      "#{@group.to_label}'s Metrics"
    when 'import_csv'
      "#{@group.to_label}'s Member CSV Import"
    when 'edit_fields'
      "#{@group.to_label}'s Survey Question Settings"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
