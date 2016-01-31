module ApplicationHelper
  def is_admin?
    current_admin
  end

  def back_to_diverst_path
    return groups_path if is_admin?
    employee_campaigns_path
  end

  def logo_url
    current_user.enterprise.theme.nil? ? image_path('diverst-logo.svg') : current_user.enterprise.theme.logo.url
  end

  def employee_avatar_url(_employee)
    return ActionController::Base.helpers.image_path('missing.png') unless linkedin_profile_url
    'TODO'
  end
end
