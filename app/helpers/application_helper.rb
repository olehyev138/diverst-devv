module ApplicationHelper
  def back_to_diverst_path
    groups_path # TODO
  end

  def logo_url
    current_user.enterprise.theme.nil? ? image_path('diverst-logo.svg') : current_user.enterprise.theme.logo.url
  end

  def last_sign_in_text(user)
    return "Never" if user.last_sign_in_at.nil?
    return "#{time_ago_in_words(user.last_sign_in_at)} ago"
  end

  def root_admin_path
    return metrics_dashboards_path if policy(MetricsDashboard).index?
    return groups_path if policy(Group).index?
    return campaigns_path if policy(Campaign).index?
    return polls_path if policy(Poll).index?
    return users_path if policy(User).index?
    nil
  end
end
