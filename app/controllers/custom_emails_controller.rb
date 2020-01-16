class CustomEmailsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_custom_email, only: [:edit, :show, :update]

  layout 'global_settings'

  # TODO implement public activity for custom mails
  #after_action :visit_page, only: [:index, :edit]

  def new
    @enterprise = current_user.enterprise
    @custom_email = current_user.enterprise.custom_emails.new
  end

  #show and perepare for sending
  def show
  end

  def edit
    @enterprise = current_user.enterprise
  end

  def create
  end

  def update
  end

  protected

  def set_custom_email
    @custom_email = current_user.enterprise.custom_emails.find(params[:id])
  end
end