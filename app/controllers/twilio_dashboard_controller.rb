class TwilioDashboardController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :set_enterprise

  layout 'global_settings'

  def index
    authorize User

    @rooms = VideoRoom.where(enterprise_id: @enterprise.id).all

    respond_to do |format|
      format.html
      format.json { render json: TwilioUsageDatatable.new(view_context, @rooms) }
    end
  end

  private

  def set_enterprise
    @enterprise = current_user.enterprise
  end
end
