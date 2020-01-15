class EmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email, only: [:edit, :update, :show]
  before_action :set_custom_email, only: [:edit_custom]
  after_action :visit_page, only: [:index, :edit]

  layout 'global_settings'

  def index
    @enterprise = current_user.enterprise
    @emails = @enterprise.emails
    @custom_emails = @enterprise.custom_emails
  end

  def edit
  end

  def update
    if @email.update(email_params)
      flash[:notice] = 'Your email was updated'
      track_activity(@email, :update)
      redirect_to action: :index
    else
      flash[:alert] = 'Your email was not updated. Please fix the errors'
      render :edit
    end
  end

  def new_custom
    @custom_email = current_user.enterprise.custom_emails.new
  end

  def edit_custom
  end

  protected

  def set_email
    @email = current_user.enterprise.emails.find(params[:id])
  end

  def set_custom_email
    @custom_email = current_user.enterprise.custom_emails.find(params[:id])
  end

  def email_params
    params
      .require(:email)
      .permit(
        :content,
        :subject
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
