class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise
  before_action :set_activities

  layout 'global_settings'

  def index
    authorize :log, :index?

    @groups = @enterprise.groups
    @q = PublicActivity::Activity.ransack(params[:q])
    @activities = Finders::Logs.new(@activities)
                                .filter_by_groups(params[:q]&.delete(:trackable_id_in).to_a)
                                .logs
    @activities_page = @activities.ransack(params[:q]).result.page(params[:page])

    respond_to do |format|
      format.html
      #For CSV logs, we send ALL the activities
      format.csv { send_data LogCsv.build(@activities), filename: log_file_name }
    end
  end

  protected

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def set_activities
    @activities = PublicActivity::Activity.includes(:owner, :trackable).where(recipient: @enterprise).order(created_at: :desc)
  end

  def log_file_name
    "logs-#{@enterprise.name}-#{Date.today}.csv"
  end
end
