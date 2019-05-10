class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :resend_invitation, :show, :group_surveys]
  after_action :verify_authorized, except: [:edit_profile, :group_surveys]

  layout :resolve_layout

  def index
    authorize User

    @users = policy_scope(User).includes(:policy_group, :user_groups, :group_leaders).where(search_params).limit(params[:limit] || 25)

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
    manageable_groups = current_user.groups.select { |group|
      GroupMemberPolicy.new(current_user, [group]).update?
    }

    @user_groups = @user.user_groups.where(group: manageable_groups).where.not(data: nil)
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

  protected

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
    params.permit(:active, :mentor, :mentee, policy_groups: [:budget_approval], user_groups: [:accepted_member, :group_id], group_leaders: [:budget_approval])
  end

  def extra_params
    params.permit(:not_current_user, :can_metrics_dashboard_create)
  end
end
