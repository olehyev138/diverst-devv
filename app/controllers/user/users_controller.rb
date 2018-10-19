class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  layout 'user'

  def show
    authorize @user
  end

  def edit
    authorize @user
    @user_groups = @user.user_groups.where(accepted_member: true)
  end

  def update
    authorize @user

    @user.assign_attributes(user_params)
    @user.info.merge(fields: @user.enterprise.fields, form_data: params['custom-fields'])

    if @user.save
      update_groups_notifications
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
      :groups_notifications_frequency,
      :groups_notifications_date,
      :mentor,
      :mentee,
      mentoring_interest_ids: []
    )
  end

  def update_groups_notifications
    @user.user_groups.where(accepted_member: true).each do |user_group| 
      user_group.update notifications_frequency: User.groups_notifications_frequencies[params[:user][:groups_notifications_frequency]],
                        notifications_date: User.groups_notifications_dates[params[:user][:groups_notifications_date]]
    end
  end
end
