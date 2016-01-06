class EmailsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_email, only: [:edit, :update, :show]

  layout "global_settings"

  def index
    @emails = current_admin.enterprise.emails
  end

  def update
    if @email.update(email_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  protected

  def set_email
    @email = current_admin.enterprise.emails.find(params[:id])
  end

  def email_params
    params
    .require(:email)
    .permit(
      :custom_html_template,
      :custom_txt_template
    )
  end
end