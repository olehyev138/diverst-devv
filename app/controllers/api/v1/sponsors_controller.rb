class Api::V1::SponsorsController < DiverstController
  def create
    type, id =
        if params[:group_id].present?
          ['Group', params[:group_id]]
        else
          ['Enterprise', current_user.enterprise.id ]
        end
    params[:sponsor][:sponsorable_type] = type
    params[:sponsor][:sponsorable_id] = id
    super
  end

  private

  def model_map(model)
    current_user.enterprise
  end

  def action_map(action)
    case action
    when :create, :update, :destroy then 'update_branding'
    else nil
    end
  end

  def payload
    params
        .require(:sponsor)
        .permit(
            :id,
            :sponsor_title,
            :sponsor_name,
            :sponsor_message,
            :sponsor_media,
            :sponsorable_type,
            :sponsorable_id,
          )
  end
end
