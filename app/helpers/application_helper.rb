module ApplicationHelper
  def back_to_diverst_path
    return groups_path if is_admin?
    user_campaigns_path
  end

  def logo_url
    current_user.enterprise.theme.nil? ? image_path('diverst-logo.svg') : current_user.enterprise.theme.logo.url
  end

  def last_sign_in_text(user)
    return "Never" if user.last_sign_in_at.nil?
    return "#{time_ago_in_words(user.last_sign_in_at)} ago"
  end
end
