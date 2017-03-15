class EmailsController < ApplicationController
  before_action :set_email, only: [:edit, :update, :show]

  layout 'global_settings'

  def index
    @enterprise = current_user.enterprise
    @emails = @enterprise.emails
  end

  def update
    if @email.update(email_params)
      flash[:notice] = "Your email was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your email was not updated. Please fix the errors"
      render :edit
    end
  end

  protected

  def set_email
    @email = current_user.enterprise.emails.find(params[:id])
  end

  def email_params
    params
      .require(:email)
      .permit(
        :use_custom_templates,
        :custom_html_template,
        :custom_txt_template,
        :subject
      )
  end
end
