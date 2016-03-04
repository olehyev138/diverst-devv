module ApplicationHelper
  def back_to_diverst_path
    groups_path # TODO
  end

  def logo_url
    current_user.enterprise.theme.nil? ? image_path('diverst-logo.svg') : current_user.enterprise.theme.logo.expiring_url(3600)
  end

  def last_sign_in_text(user)
    return "Never" if user.last_sign_in_at.nil?
    return "#{time_ago_in_words(user.last_sign_in_at)} ago"
  end

  def root_admin_path
    return manage_erg_root_path if manage_erg_root_path
    return groups_path if policy(Group).index?
    return campaigns_path if policy(Campaign).index?
    return polls_path if policy(Poll).index?
    return users_path if policy(User).index?
    nil
  end

  def manage_erg_root_path
    return metrics_dashboards_path if policy(MetricsDashboard).index?
    return groups_path if policy(Group).index?
    return segments_path if policy(Segment).index?
    nil
  end

  def global_settings_path
    return users_path if policy(User).index?
    return edit_auth_enterprise_path(current_user.enterprise) if policy(current_user.enterprise).edit_auth?
    return edit_fields_enterprise_path(current_user.enterprise) if policy(current_user.enterprise).edit_fields?
    nil
  end

  def default_path
    return root_admin_path if root_admin_path
    return user_root_path
  end
end
