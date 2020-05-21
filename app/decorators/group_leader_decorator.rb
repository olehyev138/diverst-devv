class GroupLeaderDecorator < Draper::Decorator
  def enabled_status(status)
    if status === true
      'On'
    else
      'Off'
    end
  end
end
