class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [
    :show, :edit, :update,
    :update_linkedin, :edit_linkedin, :delete_linkedin,
    :update_outlook, :edit_outlook, :delete_outlook
  ]
  after_action :visit_page, only: [:show, :edit]

  layout 'user'

  def show
    unless @user.linkedin_profile_url
      @linkedin_url = LinkedInClient.get_url
    end
    @outlook_url = OutlookAuthenticator.get_login_url

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

  def edit_outlook
    authorize @user, :edit?
    if @user.outlook_datum.present?
      @outlook = @user.outlook_datum
    else
      flash[:alert] = 'You have not added you Outlook Account'
      redirect_to :back
    end
  end

  def update_outlook
    authorize @user, :edit?
    outlook = @user.outlook_datum ||= @user.build_outlook_datum

    params[:outlook_datum] ||= {}
    params[:outlook_datum][:auto_add_event_to_calendar] ||= false
    params[:outlook_datum][:auto_update_calendar_event] ||= false

    if outlook.update(user_outlook)
      flash[:notice] = 'outlook setting have been saved'
      redirect_to user_user_path(@user)
    else
      render :edit_outlook
    end
  end

  def delete_outlook
    authorize @user, :edit?
    @user.delete_outlook_datum
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

  def user_outlook
    params.require(:outlook_datum).permit(
      :auto_add_event_to_calendar,
      :auto_update_calendar_event,
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
