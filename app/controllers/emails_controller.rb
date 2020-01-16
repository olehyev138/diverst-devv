class EmailsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_email, only: [:edit, :show]
  before_action :set_custom_email, only: [:edit_custom, :prepare_for_sending, :send]
  before_action :set_email_from_system_or_custom, only: [:update]

  after_action :visit_page, only: [:index, :edit]

  layout 'global_settings'

  def index
    @enterprise = current_user.enterprise
    @emails = @enterprise.emails
    @custom_emails = @enterprise.custom_emails
  end

  def edit
  end

  # WARNING - only allows to create custom email.
  # System emails are not allowed for users to be created
  def create
    #TODO authorize user
    @custom_email = current_user.enterprise.custom_emails.new(custom_email_params)

    if @custom_email.save
      # TODO track activity
      flash[:notice] = 'Your custom email was created'
      redirect_to action: :index
    else
      flash.now[:alert] ='Your custom email was not created, please fix errors'
      render :new_custom
    end
  end

  def update
    if @email.update(email_params)
      flash[:notice] = 'Your email was updated'
      track_activity(@email, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your email was not updated. Please fix the errors'

      if @email.custom?
        redirect_to action: :edit_custom
      else
        render :edit
      end
    end
  end

  def edit_custom
  end

  def prepare_for_sending
  end

  def send_custom
    emails = custom_email_params[:receivers].split(',').map{|i| i.strip}

    CustomEmailMailer.custom(@custom_email, emails).deliver_later

    flash[:notice] = "Your email has been sent to #{emails.count} user(s)."
    redirect_to action: :index
  end

  protected

  def set_email
    @email = current_user.enterprise.emails.find(params[:id])
  end

  def set_custom_email
    @custom_email = current_user.enterprise.custom_emails.find(params[:id])
  end

  def set_email_from_system_or_custom
    @email = current_user.enterprise.emails.find_by_id(params[:id]) ||
             current_user.enterprise.custom_emails.find(params[:id])
  end

  def email_params
    params
      .require(:email)
      .permit(
        :content,
        :subject
      )
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Email Configurations'
    when 'edit'
      'Edit Email Configurations'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
