FactoryGirl.define do
  factory :policy_group do
    campaigns_index true
    campaigns_create true
    campaigns_manage true

    polls_index true
    polls_create true
    polls_manage true

    events_index true
    events_create true
    events_manage true

    group_messages_index true
    group_messages_create true
    group_messages_manage true

    groups_index true
    groups_create true
    groups_manage true
    groups_members_index true
    groups_members_manage true

    metrics_dashboards_index true
    metrics_dashboards_create true

    news_links_index true
    news_links_create true
    news_links_manage true

    enterprise_resources_index true
    enterprise_resources_create true
    enterprise_resources_manage true

    segments_index true
    segments_create true
    segments_manage true

    users_index true
    users_manage true

    initiatives_index true
    initiatives_create true
    initiatives_manage true

    budget_approval true

    logs_view true

    groups_budgets_request true
    groups_budgets_index true
    
    annual_budget_manage true
    branding_manage true
    diversity_manage true
    sso_manage true
    manage_posts true
    global_calendar true
    permissions_manage true
  end
end
