class UsersController < ApplicationController
  before_action :set_user,
                only: [
                  :edit, :update, :destroy, :resend_invitation,
                  :show, :group_surveys, :show_usage, :user_url_usage_data
                ]
  after_action :verify_authorized, except: [:edit_profile, :group_surveys]

  layout :resolve_layout

  def index
    authorize User

    if params[:type].present? && params[:type].downcase == 'budget_permission'

      users_leaders = policy_scope(User).joins(:user_groups).joins(:group_leaders).where(leader_budget_policy_params)
      users_users = policy_scope(User).joins(:policy_group).joins(:user_groups).joins(:group_leaders).where(user_budget_policy_params)
      users_super = policy_scope(User).joins(:policy_group).joins(:group_leaders).where(super_user_params)

      @users = users_leaders.union(users_users).union(users_super).limit(params[:limit] || 25)
    else
      @users = policy_scope(User).includes(:policy_group, :user_groups, :group_leaders).where(search_params).limit(params[:limit] || 25)
    end

    if extra_params[:not_current_user]
      @users = @users.where.not(id: current_user.id)
    end

    if extra_params[:can_metrics_dashboard_create]
      user_ids_with_perms = @users.select { |u| MetricsDashboardPolicy.new(u, nil).create? }.map(&:id)
      @users = @users.where(id: user_ids_with_perms)
    end

    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context, @users) }
    end
  end

  # MISSING HTML TEMPLATE
  def sent_invitations
    authorize User, :index?
    @users = policy_scope(User).invitation_not_accepted.where(search_params)

    respond_to do |format|
      format.html
      format.json { render json: InvitedUserDatatable.new(view_context, @users) }
    end
  end

  def saml_logins
    authorize User, :index?
    @users = policy_scope(User).where(auth_source: 'saml').where(search_params)

    respond_to do |format|
      format.json { render json: UserDatatable.new(view_context, @users) }
    end
  end

  # MISSING HTML TEMPLATE
  def new
    authorize User
  end

  def show
    authorize @user
  end

  def group_surveys
    @is_own_survey = current_user == @user

    if params[:group_id].present?
      @individual = true
      group = Group.find_by_id(params[:group_id])
      @user_groups = @user.user_groups.where(group: group)
    else
      @individual = false
      @user_groups = @user.user_groups
    end
  end

  # For admins. Dedicated to editing any user's info
  def edit
    authorize @user
    @is_admin_view = true
  end

  def update
    authorize @user

    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])
    @user.seen_onboarding = true

    if @user.save
      flash[:notice] = 'Your user was updated'
      redirect_to :back
    else
      flash[:alert] = 'Your user was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to :back
  end

  def resend_invitation
    authorize @user
    @user.invite! # => reset invitation status and send invitation again
    flash[:notice] = 'Invitation Re-Sent!'
    redirect_to :back
  end

  def sample_csv
    authorize User, :index?
    send_data current_user.enterprise.users_csv(5), filename: 'diverst_import.csv'
  end

  def import_csv
    authorize User, :new?
  end

  def parse_csv
    authorize User, :new?

    if params[:file].nil?
      flash[:alert] = 'CSV file is required'
      redirect_to :back
      return
    end

    file = CsvFile.new(import_file: params[:file].tempfile, user: current_user)

    @message = ''
    @success = false
    @email = ENV['CSV_UPLOAD_REPORT_EMAIL']

    if file.save
      track_activity(current_user, :import_csv)
      @success = true
      @message = '@success'
    else
      @success = false
      @message = 'error'
      @errors = file.errors.full_messages
    end
  end

  def export_csv
    authorize User, :index?
    export_csv_params = params[:export_csv_params]
    UsersDownloadJob.perform_later(current_user.id, export_csv_params)
    track_activity(current_user, :export_csv)
    flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
    redirect_to :back
  end

  def date_histogram
    authorize User, :index?

    respond_to do |format|
      format.json {
        g = DateHistogramGraph.new(
          # index: User.es_index_name(enterprise: current_user.enterprise),
          field: 'created_at',
          interval: 'month'
        )
        data = g.query_elasticsearch

        render json: data
      }
      format.csv {
        UsersDateHistogramDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        flash[:notice] = 'Please check your Secure Downloads section in a couple of minutes'
        redirect_to :back
      }
    end
  end

  def show_usage
    authorize @user, :show?
    get_user_usage_metrics
  end

  def index_usage
    authorize User, :index?
    get_aggregate_usage_metrics
  end

  def user_url_usage_data
    authorize @user, :show?
    respond_to do |format|
      format.html
      format.json { render json: UserUsageDatatable.new(view_context, @user) }
    end
  end

  def url_usage_data
    authorize User, :index?
    respond_to do |format|
      format.html
      format.json { render json: AggregateUrlStatsDatatable.new(view_context) }
    end
  end

  protected

  def calculate_aggregate_data(sample)
    max = sample.max
    n = sample.count
    sum = sample.sum
    mean = sum.to_f / n
    sd = Math.sqrt(sample.reduce(0) { |partial, element| partial + (element - mean)**2 / n })
    return sum, max, mean.round(2), sd.round(2)
  end

  def aggregate_data_from_field(*fields, where: [nil])
    list_of_values = User.count_list(*fields, where: where)
    calculate_aggregate_data(list_of_values)
  end

  def calculate_percentile(number, sample)
    n = sample.count
    i = sample.rindex(number)
    101 - (100 * (i - 0.5) / n).round
  end

  def percentile_from_field(number, *fields, where: [nil])
    list_of_values = User.count_list(*fields, where: where)
    calculate_percentile(number, list_of_values)
  end

  def get_aggregate_usage_metrics
    logins_s, logins_m, logins_a, logins_sd = calculate_aggregate_data(User.all.map(&:sign_in_count))
    logins_n = 'Logins'

    posts_s, posts_m, posts_a, posts_sd = aggregate_data_from_field(:social_links, :own_messages, :own_news_links)
    posts_n = 'Posts Made'

    comments_s, comments_m, comments_a, comments_sd = aggregate_data_from_field(:answer_comments, :message_comments, :answer_comments)
    comments_n = 'Comments Made'

    events_s, events_m, events_a, events_sd = aggregate_data_from_field(:initiatives, where: ['initiatives.start < ?', Time.now] )
    events_n = 'Events Attendance'

    @aggregate_metrics = {}
    @fields = %w(logins posts comments events)
    @fields.each do |type|
      @aggregate_metrics[type.to_sym] = {
        sum: binding.local_variable_get("#{type}_s"),
        max: binding.local_variable_get("#{type}_m"),
        mean: binding.local_variable_get("#{type}_a"),
        sd: binding.local_variable_get("#{type}_sd"),
        name: binding.local_variable_get("#{type}_n")
      }
    end
  end

  def get_user_usage_metrics
    logins = @user.sign_in_count
    logins_p = calculate_percentile(logins, User.all.map(&:sign_in_count).sort)
    logins_n = 'Times Logged In'

    posts = @user.number_of(:social_links, :own_messages, :own_news_links)
    posts_p = percentile_from_field(posts, :social_links, :own_messages, :own_news_links)
    posts_n = 'Posts Made'

    comments = @user.number_of(:answer_comments, :message_comments, :answer_comments)
    comments_p = percentile_from_field(comments, :answer_comments, :message_comments, :answer_comments)
    comments_n = 'Comments Made'

    events = @user.number_of(:initiatives, where: ['initiatives.start < ?', Time.now])
    events_p = percentile_from_field(events, :initiatives, where: ['initiatives.start < ?', Time.now])
    events_n = 'Events Attended'

    @fields = %w(logins posts comments events)
    @user_metrics = {}
    @fields.each do |type|
      @user_metrics[type.to_sym] = {
        count: binding.local_variable_get("#{type}"),
        percentile: binding.local_variable_get("#{type}_p"),
        name: binding.local_variable_get("#{type}_n")
      }
    end

    @most_visited_pages = @user.most_viewed_pages
  end

  def resolve_layout
    case action_name
    when 'show'
      if global_settings_path
        'global_settings'
      else
        'user'
      end
    when 'edit_profile', 'group_surveys'
      'user'
    when
      if root_admin_path
        'metrics'
      else
        'user'
      end
    else
      'global_settings'
    end
  end

  def set_user
    @user = current_user.enterprise.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :avatar,
      :email,
      :first_name,
      :last_name,
      :biography,
      :active,
      :time_zone,
      :user_role_id,
      :groups_notifications_frequency,
      :groups_notifications_date,
      :custom_policy_group,
      policy_group_attributes: [
        :id,
        :campaigns_index,
        :campaigns_create,
        :campaigns_manage,
        :events_index,
        :events_create,
        :events_manage,
        :polls_index,
        :polls_create,
        :polls_manage,
        :group_messages_index,
        :group_messages_create,
        :group_messages_manage,
        :groups_index,
        :groups_create,
        :groups_manage,
        :groups_members_manage,
        :groups_members_index,
        :metrics_dashboards_index,
        :metrics_dashboards_create,
        :news_links_index,
        :news_links_create,
        :news_links_manage,
        :enterprise_resources_index,
        :enterprise_resources_create,
        :enterprise_resources_manage,
        :segments_index,
        :segments_create,
        :segments_manage,
        :users_index,
        :users_manage,
        :initiatives_index,
        :initiatives_create,
        :initiatives_manage,
        :budget_approval,
        :logs_view,
        :groups_budgets_index,
        :groups_budgets_request,
        :budget_approval,
        :group_leader_manage,
        :sso_manage,
        :permissions_manage,
        :diversity_manage,
        :manage_posts,
        :branding_manage,
        :global_calendar,
        :manage_all,
        :enterprise_manage,
        :groups_budgets_manage,
        :group_leader_index,
        :groups_insights_manage,
        :groups_layouts_manage,
        :group_resources_index,
        :group_resources_create,
        :group_resources_manage,
        :social_links_index,
        :social_links_create,
        :social_links_manage,
        :group_settings_manage,
        :group_posts_index,
        :mentorship_manage
      ]
    )
  end

  def search_params
    params.permit(:active, :mentor, :mentee, policy_groups: [:budget_approval], user_groups: [:accepted_member, :group_id], group_leaders: [:budget_approval, :group_id])
  end

  def leader_budget_policy_params
    params.permit(group_leaders: [:budget_approval, :group_id])
  end

  def user_budget_policy_params
    params.permit(policy_groups: [:budget_approval], group_leaders: [:group_id])
  end

  def super_user_params
    params.permit(policy_groups: [:manage_all])
  end

  def extra_params
    params.permit(:not_current_user, :can_metrics_dashboard_create)
  end
end
