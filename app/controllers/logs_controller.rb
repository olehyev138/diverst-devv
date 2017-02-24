class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise
  before_action :set_activities

  layout 'global_settings'

  def index
    authorize :log, :index?
  end

  protected

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_activities
    @activities = PublicActivity::Activity.includes(:owner, :trackable)
                                          .where(recipient: @enterprise)
                                          .order(created_at: :desc)
                                          .limit(200)
  end
end