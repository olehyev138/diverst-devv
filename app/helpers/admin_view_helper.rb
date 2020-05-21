module AdminViewHelper
  def active_manage_erg_link?
    return true if controller_name == 'groups' &&
      ['calendar', 'index', 'import_csv', 'edit', 'new'].include?(action_name)
    return true if controller_name == 'enterprises' && ['resources'].include?(action_name)
    return true if ['groups/resources', 'enterprises/resources', 'enterprises/folders', 'archived_posts'].include? params[:controller]

    ['segments'].include? controller_name
  end

  def active_engage_link?
    ['campaigns', 'expenses', 'expense_categories'].include? controller_name
  end

  def active_plan_link?
    return true if controller_name == 'groups' && ['close_budgets'].include?(action_name)
  end

  def active_global_settings_link?
    return true if controller_name == 'groups' && [].include?(action_name)
    return true if controller_name == 'enterprises' &&
      ['edit_auth', 'edit_fields', 'edit_branding', 'edit_budgeting', 'edit_posts'].include?(action_name)

    ['users', 'integrations', 'policy_group_templates', 'emails', 'notifications', 'rewards', 'logs'].include? controller_name
  end

  def show_settings_link?
    return true if EnterprisePolicy.new(current_user, current_user.enterprise).sso_manage?
    return true if EnterprisePolicy.new(current_user, current_user.enterprise).manage_permissions?
    return true if EnterprisePolicy.new(current_user, current_user.enterprise).manage_branding?

    false
  end

  def show_diversity_link?
    return true if EnterprisePolicy.new(current_user, current_user.enterprise).diversity_manage?
    return true if GroupPolicy.new(current_user, Group).manage_all_groups? && EnterprisePolicy.new(current_user, current_user.enterprise).manage_posts?

    false
  end
end
