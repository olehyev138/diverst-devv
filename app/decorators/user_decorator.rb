class UserDecorator < Draper::Decorator
  def active_status
    if user.active?
      'Active'
    else
      'Inactive'
    end
  end

  def mentoring_status(boolean)
    if boolean
      'Yes'
    else
      'No'
    end
  end
end
