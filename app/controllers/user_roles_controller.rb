class UserRolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy_group_template, only: [:edit, :update, :destroy]

  layout 'global_settings'

  def index
    authorize UserRole
    @user_roles = current_user.enterprise.user_roles
  end

  def new
    authorize UserRole
    @user_role = current_user.enterprise.user_roles.new
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

    if @policy_group_template.update(policy_group_template_params)
      flash[:notice] = "Your user role was updated"
      redirect_to users_url
    else
      flash[:alert] = "Your user role was not updated. Please fix the errors"
      render :edit
    end
  end

  protected

  def set_policy_group_template
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
        :role_type
      )
  end
end
