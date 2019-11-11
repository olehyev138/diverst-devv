class User::DownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_csv_file, only: [:download]
  after_action :visit_page, only: [:index]

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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'User\'s Downloads Page'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
