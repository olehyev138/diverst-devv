class UserRoleDecorator < Draper::Decorator
  def default_role
    if user_role.default?
      'Yes'
    else
      'No'
    end
  end
end
