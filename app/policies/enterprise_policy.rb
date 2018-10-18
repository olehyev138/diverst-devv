class EnterprisePolicy < ApplicationPolicy
  
  def update?
    return true if manage_all?
    @policy_group.enterprise_manage?
  end

  def edit_auth?
    return true if manage_all?
    @policy_group.sso_manage?
  end

  def edit_fields?
    return true if manage_all?
    @policy_group.branding_manage?
  end

  def edit_mobile_fields?
    return true if manage_all?
    @policy_group.branding_manage?
  end

  def manage_posts?
    return true if manage_all?
    @policy_group.manage_posts?
  end

  def diversity_manage?
    return true if manage_all?
    @policy_group.diversity_manage?
  end

  # Branding

  def update_branding?
    return true if manage_all?
    @policy_group.branding_manage?
  end

  def edit_branding?
    update_branding?
  end

  def edit_pending_comments?
    return true if manage_all?
    @policy_group.manage_posts?
  end

  def restore_default_branding?
    update_branding?
  end
end
