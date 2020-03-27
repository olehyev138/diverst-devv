class Api::V1::UserGroupsController < DiverstController
  def join
    params[klass.symbol][:user_id] = current_user.id
    create
  end

  def leave
    params[klass.symbol][:user_id] = current_user.id
    item = klass.find_by(payload)

    item.remove
  end

  private

  def payload
    params.require(klass.symbol).permit(
        :user_id,
        :group_id,
      )
  end
end
