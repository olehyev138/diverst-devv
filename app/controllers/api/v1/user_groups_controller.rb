class Api::V1::UserGroupsController < DiverstController
  def create
    params[klass.symbol][:user_id] = current_user.id
    super
  end

  def remove
    params[klass.symbol][:user_id] = current_user.id
    item = klass.find_by(payload)

    return if item.nil?

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
