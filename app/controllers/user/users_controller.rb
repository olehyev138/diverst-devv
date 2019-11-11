class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :update_linkedin, :edit_linkedin, :delete_linkedin]
  after_action :visit_page, only: [:show, :edit]

  layout 'user'

  def show
    unless @user.linkedin_profile_url
      @linkedin_url = LinkedInClient.get_url
    end

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
      flash[:notice] = 'Your user was updated'
      redirect_to user_user_path(@user)
    else
      flash[:alert] = 'Your user was not updated. Please fix the errors'
      render :edit
    end
  end

  def mentorship
  end

  def edit_linkedin
    authorize @user, :edit?
  end

  def update_linkedin
    @user.assign_attributes(user_linkedin)

    if @user.save
      flash[:notice] = 'LinkedIn has be integrated'
      redirect_to user_user_path(@user)
    else
      render :edit_linkedin
    end
  end

  def delete_linkedin
    @user.delete_linkedin_info
    redirect_to user_user_path(@user)
  end

  protected

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :avatar,
      :email,
      :notifications_email,
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

  def user_linkedin
    params.require(:user).permit(
      :linkedin_profile_url
    )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'show'
      "#{@user.to_label}'s Profile"
    when 'edit'
      "#{@user.to_label}'s Profile Edit"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
