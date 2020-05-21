enterprise = Enterprise.create(
name: 'REPLACE_ME 2'
)

enterprise.theme = Theme.new(primary_color: '#cccccc')

enterprise.save

policy_group = enterprise.policy_groups.create(
  name: "Superadmins",

  campaigns_index: true,
  campaigns_create: true,
  campaigns_manage: true,

  polls_index: true,
  polls_create: true,
  polls_manage: true,

  events_index: true,
  events_create: true,
  events_manage: true,

  group_messages_index: true,
  group_messages_create: true,
  group_messages_manage: true,

  groups_index: true,
  groups_create: true,
  groups_manage: true,
  groups_members_index: true,
  groups_members_manage: true,

  metrics_dashboards_index: true,
  metrics_dashboards_create: true,

  news_links_index: true,
  news_links_create: true,
  news_links_manage: true,

  enterprise_resources_index: true,
  enterprise_resources_create: true,
  enterprise_resources_manage: true,

  segments_index: true,
  segments_create: true,
  segments_manage: true,

  users_index: true,
  users_manage: true,

  initiatives_index: true,
  initiatives_create: true,
  initiatives_manage: true,

  global_settings_manage: true,
  admin_pages_view: true,
  budget_approval: true
)

u1 = enterprise.users.create(
  email: 'REPLACE_ME@diverst.com',
  first_name: 'Admin',
  last_name: 'Admin',
  password: 'aed34BOd2@j3d_REPLACE_ME',
  password_confirmation: 'aed34BOd2@j3d_REPLACE_ME',
  policy_group: policy_group,
  invitation_accepted_at: Time.current
)