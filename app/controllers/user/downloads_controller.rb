class User::DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_csv_file, only: [:download]

  layout 'user'

  def index
    @downloads = current_user.csv_files.download_files.order(created_at: :desc)
  end

  def download
    redirect_to @csv_file.download_file.expiring_url(5.minutes)
  end

  protected

  def set_csv_file
    @csv_file = current_user.csv_files.find(params[:download_id])
  end

  def download_params
    params.require(:download).permit(
      :download_id,
    )
  end
end
