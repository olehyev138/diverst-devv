class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activities

  layout 'erg_manager'

  def index
  end

  protected

  def set_activities
    #TODO only load activities from current enterprise
    @activities = PublicActivity::Activity.all
  end
end
