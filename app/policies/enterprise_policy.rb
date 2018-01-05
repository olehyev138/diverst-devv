class EnterprisePolicy < ApplicationPolicy
  def update?
    @policy_group.global_settings_manage?
  end

  # Edit pages

  def edit_auth?
    @policy_group.global_settings_manage?
  end

  def edit_fields?
    @policy_group.global_settings_manage?
  end

  def edit_mobile_fields?
    @policy_group.global_settings_manage?
  end

  # Branding

  def update_branding?
    @policy_group.global_settings_manage?
  end

  def edit_branding?
    update_branding?
  end
  
  def edit_pending_comments?
    update?
  end

  def restore_default_branding?
    update_branding?
  end
end
