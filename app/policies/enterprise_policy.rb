class EnterprisePolicy < ApplicationPolicy
  def update?
    return true if manage_all?
    return true if basic_group_leader_permission?('enterprise_manage')
    return true if enterprise_manage?

    @policy_group.enterprise_manage?
  end

  def update_enterprise?
    update?
  end

  def get_enterprise?
    update? || sso_manage?
  end

  def update_sso?
    sso_manage?
  end

  def fields?
    edit_fields?
  end

  def edit_auth?
    return true if manage_all?
    return true if basic_group_leader_permission?('sso_manage')

    @policy_group.sso_manage?
  end

  def edit_fields?
    return true if manage_all?
    return true if basic_group_leader_permission?('sso_manage')

    @policy_group.sso_manage?
  end

  alias :create_field? :edit_fields?

  def edit_mobile_fields?
    return true if manage_all?
    return true if basic_group_leader_permission?('sso_manage')

    @policy_group.sso_manage?
  end

  def manage_posts?
    return true if manage_all?
    return true if basic_group_leader_permission?('manage_posts')

    @policy_group.manage_posts?
  end

  def manage_branding?
    return true if manage_all?
    return true if basic_group_leader_permission?('branding_manage')

    @policy_group.branding_manage?
  end

  def manage_permissions?
    return true if manage_all?
    return true if basic_group_leader_permission?('permissions_manage')

    @policy_group.permissions_manage?
  end

  def sso_manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('sso_manage')

    @policy_group.sso_manage?
  end

  def auto_archive_settings_manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('auto_archive_manage')

    @policy_group.auto_archive_manage?
  end

  def diversity_manage?
    return true if manage_all?
    return true if basic_group_leader_permission?('diversity_manage')

    @policy_group.diversity_manage?
  end

  # Branding

  def update_branding?
    return true if manage_all?
    return true if basic_group_leader_permission?('branding_manage')

    @policy_group.branding_manage?
  end

  def edit_branding?
    update_branding?
  end

  def edit_pending_comments?
    return true if manage_all?
    return true if basic_group_leader_permission?('manage_posts')

    @policy_group.manage_posts?
  end

  def enterprise_manage?
    return true if manage_all?

    @policy_group.enterprise_manage?
  end

  def restore_default_branding?
    update_branding?
  end
end
