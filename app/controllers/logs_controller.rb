class LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise

  layout 'global_settings'

  def index
    authorize :log, :index?

    respond_to do |format|
      format.html {
        @activities = PublicActivity::Activity.includes(:owner, :trackable).where(recipient: @enterprise).order(created_at: :desc)
        @groups = @enterprise.groups
        @q = PublicActivity::Activity.ransack(params[:q])
        @activities = Finders::Logs.new(@activities)
                                    .filter_by_groups(params[:q]&.delete(:trackable_id_in).to_a)
                                    .logs
        @activities_page = @activities.ransack(params[:q]).result.page(params[:page])
      }
      #For CSV logs, we send ALL the activities
      format.csv {
        LogsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  protected

  def set_enterprise
    @enterprise = current_user.enterprise
  end
end
