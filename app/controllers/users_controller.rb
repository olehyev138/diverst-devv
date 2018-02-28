class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :resend_invitation, :show, :group_surveys]
  after_action :verify_authorized, except: [:edit_profile, :group_surveys]

  layout :resolve_layout

  def index
    authorize User
    @users = policy_scope(User).where(search_params)

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
    @users = policy_scope(User).where(auth_source: "saml").where(search_params)

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
    manageable_group_ids = current_user.manageable_groups.map{ |mg| mg.id}

    @user_groups = @user.user_groups.where(group_id: manageable_group_ids)
                                    .where.not(data: nil)
  end

  #For admins. Dedicated to editing any user's info
  def edit
    authorize @user
  end

  def update
    authorize @user

    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])

    if @user.save
      flash[:notice] = "Your user was updated"
      redirect_to :back
    else
      flash[:alert] = "Your user was not updated. Please fix the errors"
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
    flash[:notice] = "Invitation Re-Sent!"
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
    @importer = Importers::Users.new(params[:file].tempfile, current_user)
    @importer.import
  end

  def export_csv
    authorize User, :index?
    send_data current_user.enterprise.users_csv(nil), filename: 'diverst_users.csv'
  end

  def date_histogram
    authorize User, :index?

    g = DateHistogramGraph.new(
      index: User.es_index_name(enterprise: current_user.enterprise),
      field: 'created_at',
      interval: 'month'
    )
    data = g.query_elasticsearch

    respond_to do |format|
      format.json {
        render json: data
      }
      format.csv {
        strategy = Reports::GraphTimeseriesGeneric.new(
          title: 'Number of employees',
          data: data["aggregations"]["my_date_histogram"]["buckets"].collect{ |data| [data["key"], data["doc_count"]] }
        )
        report = Reports::Generator.new(strategy)
        send_data report.to_csv, filename: "employees.csv"
      }
    end
  end

  protected

  def resolve_layout
    case action_name
    when 'show'
      if current_user.policy_group.admin_pages_view
        'global_settings'
      else
        'user'
      end
    when 'edit_profile'
      'user'
    else
      'global_settings'
    end
  end

  def set_user
    current_user ? @user = current_user.enterprise.users.find(params[:id]) : user_not_authorized
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
      :role,
      policy_group_attributes: [
        :id,
        :admin_pages_view,
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
        :global_settings_manage,
        :initiatives_index,
        :initiatives_create,
        :initiatives_manage,
        :budget_approval,
        :logs_view,
        :groups_budgets_index,
        :groups_budgets_request,
        :annual_budget_manage,
        :sso_manage,
        :permissions_manage,
        :group_leader_manage,
        :diversity_manage,
        :manage_posts
      ]
    )
  end

  def search_params
    params.permit(:active)
  end
end
