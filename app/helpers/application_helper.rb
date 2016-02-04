module ApplicationHelper
  def is_admin?
    current_admin
  end

  def is_owner?
    current_admin && current_admin.owner?
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

  def can_manage_group?(group)
    is_admin? || group.managers.include?(current_user)
  end

  def can_edit_resource?(resource)
    is_owner? || current_admin == resource.admin
  end

  def last_sign_in_text(user)
    return "Never" if user.last_sign_in_at.nil?
    return "#{time_ago_in_words(user.last_sign_in_at)} ago"
  end
end
