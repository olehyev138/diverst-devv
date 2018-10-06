class UserRolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_role, only: [:edit, :update, :destroy]

  layout 'global_settings'

  def new
    authorize UserRole
    @user_role = current_user.enterprise.user_roles.new
    @user_role.role_name = ""
  end
  
  def edit
    authorize UserRole
  end

  def create
    authorize UserRole

    @user_role = current_user.enterprise.user_roles.new(user_role_params)

    if @user_role.save
      flash[:notice] = "Your user role was created"
      redirect_to users_url
    else
      flash[:alert] = "Your user role was not created. Please fix the errors"
      render :new
    end
  end

  def update
    authorize UserRole

    if @user_role.update(user_role_params)
      flash[:notice] = "Your user role was updated"
      redirect_to users_url
    else
      flash[:alert] = "Your user role was not updated. Please fix the errors"
      render :edit
    end
  end
  
  def destroy
    authorize @user_role
    if not @user_role.destroy
      flash[:alert] = @user_role.errors.full_messages.first
    end
    redirect_to :back
  end

  protected

  def set_user_role
    if current_user
      @user_role = current_user.enterprise.user_roles.find(params[:id])
    else
      user_not_authorized
    end
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
end
