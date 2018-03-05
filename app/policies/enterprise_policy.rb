class EnterprisePolicy < ApplicationPolicy
  def update?
    @policy_group.branding_manage?
  end
  # Edit pages

  def edit_auth?
    @policy_group.sso_manage?
  end

  def edit_fields?
    @policy_group.branding_manage?
  end

  def edit_mobile_fields?
    @policy_group.branding_manage?
  end
  
  def manage_posts?
    @policy_group.manage_posts?
  end
  
  def diversity_manage?
    @policy_group.diversity_manage?
  end

  # Branding

  def update_branding?
    @policy_group.branding_manage?
  end

  def edit_branding?
    update_branding?
  end

  def edit_pending_comments?
    @policy_group.manage_posts?
  end

  def restore_default_branding?
    update_branding?
  end

  def sponsor_message_visibility?
    case @record.disable_sponsor_message
    when true #i.e  when disable_sponsor_message is true return false for this policy
        return false
    when false #i.e when disable_sponsor_message is false return true for this policy
        return true
    end
  end
end
