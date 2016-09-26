class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized, except: [:edit_profile]

  layout :resolve_layout

  def index
    authorize User
    @users = policy_scope(User)

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

  #For regular users. Dedicated to editing own profile only.
  def edit_profile
    @user = current_user

    render :edit
  end

  def update
    authorize @user

    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])

    if @user.save
      if @user.policy_group.admin_pages_view?
        redirect_to @user
      else
        redirect_to user_user_path(@user)
      end
    else
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

    @table = CSV.table params[:file].tempfile
    @failed_rows = []
    @successful_rows = []

    @table.each_with_index do |row, row_index|
      user = User.from_csv_row(row, enterprise: current_user.enterprise)

      if user
        if user.save
          user.invite!(current_user)
          @successful_rows << row
        else
          # ActiveRecord validation failed on user
          @failed_rows << {
            row: row,
            row_index: row_index + 1,
            error: user.errors.full_messages.join(', ')
          }
        end
      else
        # User.from_csv_row returned nil
        @failed_rows << {
          row: row,
          row_index: row_index + 1,
          error: 'Missing required information'
        }
      end
    end
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

    render json: g.query_elasticsearch
  end

  protected

  def resolve_layout
    case action_name
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
      :email,
      :first_name,
      :last_name,
      :job_title
    )
  end
end
