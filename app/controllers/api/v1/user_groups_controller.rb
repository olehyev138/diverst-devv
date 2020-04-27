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

  def join_subgroups
    UserGroup.find_or_create_by(group_id: subgroup_payload[:group_id], user_id: current_user.id)
    subgroup_payload[:subgroups].each do | group |
      if group[:join]
        UserGroup.find_or_create_by(group_id: group[:group_id], user_id: current_user.id)
      else
        item = UserGroup.find_by(group_id: group[:group_id], user_id: current_user.id)
        unless item.nil?
          item.remove
        end
      end
    end
  rescue => e
    raise BadRequestException.new(e.message)
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
      
  def subgroup_payload
    params.permit(
    :group_id,
    subgroups:
        [
            :group_id,
            :join
        ]
  )
  end

  def payload
    params.require(klass.symbol).permit(
        :user_id,
        :group_id,
      )
  end
end
