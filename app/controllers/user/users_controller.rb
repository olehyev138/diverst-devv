class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  layout 'user'

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])

    if @user.save
      flash[:notice] = "Your user was updated"
      redirect_to user_user_path(@user)
    else
      flash[:alert] = "Your user was not updated. Please fix the errors"
      render :edit
    end
  end
  
  def mentorship
  end

  protected

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :avatar,
      :email,
      :first_name,
      :last_name,
      :biography,
      :time_zone,
      :mentor,
      :mentee,
      mentoring_interest_ids: []
    )
  end
end
