class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise
  before_action :set_activities

  layout 'erg_manager'

  def index
  end

  protected

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_activities
    @activities = PublicActivity::Activity.where(recipient: @enterprise)
  end
end
