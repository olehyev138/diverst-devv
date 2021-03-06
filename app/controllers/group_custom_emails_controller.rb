
class GroupCustomEmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_custom_email, only: [:show, :edit, :update, :destroy, :deliver]
  #before_action :set_field, only: [:time_series]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :edit?

    @custom_emails = @group.custom_emails
  end

  def show
    authorize @group, :edit?
  end

  def new
    authorize @group, :edit?

    @custom_email = @group.custom_emails.new

    @submit_url = group_group_custom_emails_path(@group.id)
    @submit_method = 'post'
  end

  def create
    authorize @group, :edit?

    @custom_email = @group.custom_emails.new(custom_email_params)

    if @custom_email.save
      # TODO track activity
      flash[:notice] = 'Your custom email was created'
      redirect_to group_group_custom_emails_path(@group)
    else
      flash.now[:alert] = 'Your custom email was not created, please fix errors'
      render :new_email
    end
  end

  def edit
    authorize @group, :edit?

    @submit_url = group_group_custom_email_path(@group, @custom_email)
    @submit_method = 'patch'
  end

  def update
    authorize @group, :edit?

    if @custom_email.update(custom_email_params)
      flash[:notice] = 'Your custom email was updated'
      # TODO track activity
      # track_activity(@email, :update)
      redirect_to group_group_custom_emails_path(@group)
    else
      flash[:alert] = 'Your custom email was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @group, :edit?
    # TODO track activity

    # oOnly custom emails can be destroyed by userss
    if @custom_email.custom? && @custom_email.destroy
      flash[:notice] = 'Your custom email was deleted'
    else
      flash[:alert] = 'Your custom email could not be deleted.'
    end
    redirect_to group_group_custom_emails_path(@group)
  end

  def deliver
    authorize @group, :edit?
    # TODO authenticate

    plaintext_emails = custom_email_params[:receivers].split(',').map { |i| i.strip }
    receivers_groups_ids = custom_email_params[:receiver_groups_ids]

    CustomEmailMailer.custom(@custom_email.id, plaintext_emails, current_user.id, receivers_groups_ids).deliver_later

    # TODO calculate how manu users got an email
    flash[:notice] = 'Your email has been sent.'

    redirect_to group_group_custom_emails_path(@group)
  end


  protected

  def set_custom_email
    @custom_email = @group.custom_emails.find params[:id]
  end

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def custom_email_params
    params
      .require(:email)
      .permit(
        :name,
        :description,
        :content,
        :subject,
        :receivers,
        receiver_groups_ids: []
      )
  end
end
