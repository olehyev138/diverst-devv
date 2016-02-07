class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  layout 'user'

  def update
    redirect_to [:user, @user] if @user != current_user && !current_user.is_a?(Admin)

    if @user.update_attributes(user_params)
      redirect_to [:user, @user]
    else
      render :edit
    end
  end

  protected

  def set_user
    @user = current_user.enterprise.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
