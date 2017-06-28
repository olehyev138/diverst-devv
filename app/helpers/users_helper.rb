module UsersHelper
  def user_performance_label(user)
    label = get_label(user)
    label += " (#{ user.total_weekly_points })" if ENV['REWARDS_ENABLED']
  end

  def user_group_performance_label(user_group)
    label = get_label(user_group.user)
    label += " (#{ user_group.total_weekly_points })" if ENV['REWARDS_ENABLED']
  end

  def get_label(user)
    if user == current_user
      user.name_with_status
    else
      link_to user.name_with_status, user
    end
  end
end
