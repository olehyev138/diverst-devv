class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized, except: [:edit_profile]

  layout :resolve_layout

  def index
    authorize User
    @users = policy_scope(User).where(search_params)

    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context, @users) }
    end
  end

  def new
    authorize User
  end

  def show
    authorize @user
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
      redirect_to @user
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
    @user = current_user.enterprise.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :avatar,
      :email,
      :first_name,
      :last_name,
      :biography,
      :active
    )
  end

  def search_params
    params.permit(:active)
  end
end
