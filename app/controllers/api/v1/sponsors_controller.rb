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
end
