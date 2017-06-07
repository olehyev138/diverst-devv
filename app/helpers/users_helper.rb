module UsersHelper
  def user_performance_label(user)
    label =
      if user == current_user
        user.name_with_status
      else
        link_to user.name_with_status, user
      end
    label += " (#{ user.participation_score_7days })" if ENV['REWARDS_ENABLED']
  end
end
