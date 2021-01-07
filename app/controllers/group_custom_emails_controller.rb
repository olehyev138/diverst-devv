
class GroupCustomEmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  #before_action :set_field, only: [:time_series]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group

    @custom_emails = @group.custom_emails
  end

  def new
    authorize @group

    @custom_email = @group.custom_emails.new

    @submit_url = create_new_email_group_path(@group)
    @submit_method = 'post'
  end

  def create
    authorize @group, :new_email?

    @custom_email = @group.custom_emails.new(custom_email_params)

    if @custom_email.save
      # TODO track activity
      flash[:notice] = 'Your custom email was created'
      redirect_to emails_group_path(@group)
    else
      flash.now[:alert] = 'Your custom email was not created, please fix errors'
      render :new_email
    end
  end

  def edit
    authorize @group
    #TODO throw exception if email_id param is not present
    email_id = params[:email_id]
    @custom_email = @group.custom_emails.find(email_id)

    @submit_url = update_email_group_path(@group)
    @submit_method = 'patch'
  end

  def update
    authorize @group, :edit_email?

    @custom_email = @group.custom_emails.find params[:email_id]
    if @custom_email.update(custom_email_params)
      flash[:notice] = 'Your custom email was updated'
      # TODO track activity
      # track_activity(@email, :update)
      redirect_to emails_group_path(@group)
    else
      flash[:alert] = 'Your custom email was not updated. Please fix the errors'
      render :edit
    end
  end


  protected

  def set_custom_email

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
