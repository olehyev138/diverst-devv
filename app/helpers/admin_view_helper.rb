module AdminViewHelper
  def active_manage_erg_link?
    return true if controller_name == 'groups' &&
      ['calendar', 'index', 'import_csv', 'edit', 'new'].include?(action_name)
    return true if controller_name == 'enterprises' && ['resources'].include?(action_name)
    return true if ['groups/resources', 'enterprises/resources'].include? params[:controller]

    ['segments', 'metrics_dashboards'].include? controller_name
  end

  def active_engage_link?
    ['campaigns', 'expenses', 'expense_categories'].include? controller_name
  end

  def active_plan_link?
    return true if controller_name == 'groups' &&
      ['edit_fields', 'plan_overview', 'metrics', 'budgets', 'request_budget', 'view_budget', 'close_budgets'].include?(action_name)

    return true if params[:controller] == 'initiatives/resources'

    ['initiatives', 'outcomes', 'updates'].include? controller_name
  end

  def active_global_settings_link?
    return true if controller_name == 'groups' && [].include?(action_name)
    return true if controller_name == 'enterprises' &&
      ['edit_auth', 'edit_fields', 'edit_branding', 'edit_budgeting'].include?(action_name)

    ['users', 'integrations', 'policy_groups', 'emails', 'notifications'].include? controller_name
  end
end
