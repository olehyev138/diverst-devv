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

  private def action_map(action)
    case action
    when :create then 'import'
    else nil
    end
  end

  private def model_map(model)
    if params[:group_id]
      Group.find(params[:group_id])
    else
      current_user.enterprise
    end
  end
end
