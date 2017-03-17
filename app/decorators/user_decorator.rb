class UserDecorator < Draper::Decorator
  def active_status
    if user.active?
      'Active'
    else
      'Inactive'
    end
  end
end