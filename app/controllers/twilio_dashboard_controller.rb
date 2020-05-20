class TwilioDashboardController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_enterprise

  layout 'global_settings'

  def index
    authorize User
  end

  private

  def set_enterprise
    @enterprise = current_user.enterprise
  end
end
