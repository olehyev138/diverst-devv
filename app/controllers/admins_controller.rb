class AdminsController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_admin, only: [:edit, :update, :destroy, :show]

  layout 'global_settings'

  def index
    @admins = current_admin.enterprise.admins.not_owners
  end

  def new
    @admin = current_admin.enterprise.admins.new
  end

  def create
    @admin = current_admin.enterprise.admins.new(admin_params)

    if @admin.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    if @admin.update(admin_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @admin.destroy
    redirect_to action: :index
  end

  protected

  def set_admin
    @admin = current_admin.enterprise.admins.find(params[:id])
  end

  def admin_params
    params
      .require(:admin)
      .permit(
        :id,
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation
      )
  end
end
