class Api::V1::UserGroupsController < DiverstController
  def create
    params[klass.symbol][:user_id] = current_user.id
    super
  end

  def leave
    params[klass.symbol][:user_id] = current_user.id
    item = klass.find_by(payload)

    return if item.nil?

    item.remove
  end

  alias_method :join, :create
end
