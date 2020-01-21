class CustomEmailsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_custom_email, only: [:edit, :show, :update]

  layout 'global_settings'

  # TODO implement public activity for custom mails
  #after_action :visit_page, only: [:index, :edit]

  def new
    @enterprise = current_user.enterprise
    @custom_email = current_user.enterprise.custom_emails.new

    @submit_url = custom_emails_path
    @submit_method = 'post'
  end

  #show and perepare for sending
  def show
  end

  def edit
    @submit_url = custom_email_path(@custom_email)
    @submit_method = 'patch'
  end

  def create
    # TODO authorize user

    @custom_email = current_user.enterprise.custom_emails.new(custom_email_params)

    if @custom_email.save
      # TODO track activity
      flash[:notice] = 'Your custom email was created'
      redirect_to emails_path
    else
      flash.now[:alert] = 'Your custom email was not created, please fix errors'
      render :new
    end
  end

  def update
    # TODO check permissions
    if @custom_email.update(custom_email_params)
      flash[:notice] = 'Your custom email was updated'
      # TODO track activity
      # track_activity(@email, :update)
      redirect_to emails_path
    else
      flash[:alert] = 'Your custom email was not updated. Please fix the errors'
      render :edit
    end
  end

  protected

  def set_custom_email
    @custom_email = current_user.enterprise.custom_emails.find(params[:id])
  end

  def custom_email_params
    params
      .require(:email)
      .permit(
        :name,
        :description,
        :content,
        :subject,
        :receivers
      )
  end
end