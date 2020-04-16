class Api::V1::UserGroupsController < DiverstController
  def join
    params[klass.symbol][:user_id] = current_user.id
    create
  end

  def leave
    params[klass.symbol][:user_id] = current_user.id
    item = klass.find_by(payload)

    return if item.nil?

    item.remove
  end

  private

  def model_map(model)
    Group.find_by_id(params[:group_id].presence)
  end

  def action_map(action)
    case action
    when :export_csv then 'export_members'
    else nil
    end
  end

  def payload
    params.require(klass.symbol).permit(
        :user_id,
        :group_id,
      )
  end
end
