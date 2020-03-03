class Api::V1::CsvFilesController < DiverstController
  def create
    params[:csvfile] && (params[:csvfile][:user_id] = current_user.id)
    super
  end

  def payload
    params
        .require(:csvfile)
        .permit(
            :user_id,
            :group_id,
            :import_file
          )
  end
end
