class UserRolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_role, only: [:edit, :update, :destroy]
  after_action :visit_page, only: [:new, :edit]

  layout 'global_settings'

  def new
    authorize UserRole
    @user_role = current_user.enterprise.user_roles.new
    @user_role.role_name = ''
  end

  def edit
    authorize UserRole
  end

  def create
    authorize UserRole

    @user_role = current_user.enterprise.user_roles.new(user_role_params)

    if @user_role.save
      flash[:notice] = 'Your user role was created'
      track_activity(@user_role, :create)
      redirect_to users_url
    else
      flash[:alert] = 'Your user role was not created. Please fix the errors'
      render :new
    end
  end

  def update
    authorize UserRole

    if @user_role.update(user_role_params)
      flash[:notice] = 'Your user role was updated'
      track_activity(@user_role, :update)
      redirect_to users_url
    else
      flash[:alert] = 'Your user role was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @user_role
    track_activity(@user_role, :destroy)
    if not @user_role.destroy
      flash[:alert] = @user_role.errors.full_messages.first
    end
    redirect_to :back
  end

  protected

  def set_user_role
    @user_role = current_user.enterprise.user_roles.find(params[:id])
  end

  def user_role_params
    params
      .require(:user_role)
      .permit(
        :role_name,
        :role_type,
        :priority
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'new'
      'User Role Creation'
    when 'edit'
      "User Role Edit: #{@user_role}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
