module AdminViewHelper
  def active_manage_erg_link?
   return false unless ['enterprises',
                        'groups',
                        'resources',
                        'segments',
                        'metrics_dashboards'].include? controller_name


   return false unless ['index', 'edit', 'show', 'new', 'calendar'].include? action_name

   true
  end

  def active_champaigns_link?
    return false unless ['campaigns', 'questions', 'expenses', 'expense_categories'].include? controller_name

    true
  end

  def active_plan_link?
    if controller_name == 'groups' && (action_name == 'index' || action_name == 'edit' || action_name == 'new')
      return false
    end

    return false unless ['groups', 'initiatives', 'outcomes', 'updates'].include? controller_name

    return false if ['calendar', 'edit_annual_budget'].include? action_name

    true
  end

  def active_global_settings_link?
    return false unless ['users',
                          'groups',
                          'enterprises',
                          'integrations',
                          'policy_groups',
                          'emails'
                        ].include? controller_name

    return false unless ['index',
                          'edit',
                          'show',
                          'new',
                          'edit_auth',
                          'edit_fields',
                          'edit_branding',
                          'edit_budgeting',
                          'edit_annual_budget'
                          ].include? action_name

    true
  end
end
