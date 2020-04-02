import { ROUTES } from 'containers/Shared/Routes/constants';

const NameToPathMap = Object.freeze({
  metrics_overview: ROUTES.admin.analyze.overview,
  groups_create: ROUTES.admin.manage.groups.index,
  segments_create: ROUTES.admin.manage.segments.index,
  groups_calendars: null,
  enterprise_folders_view: ROUTES.admin.manage.resources.index,
  groups_budget_manage: ROUTES.admin.plan.budgeting.index,
  campaigns_create: ROUTES.admin.innovate.campaigns.index,
  polls_create: null,
  mentoring_interests_manage: null,
  users_create: ROUTES.admin.system.users.index,
  sso_authentication: ROUTES.admin.system.globalSettings.ssoSettings.edit,
  policy_templates_manage: ROUTES.admin.system.users.policy_templates.index,
  fields_manage: ROUTES.admin.system.globalSettings.fields.index,
  branding_manage: ROUTES.admin.system.branding.index,
  custom_text_manage: ROUTES.admin.system.globalSettings.customText.edit,
  emails_manage: ROUTES.admin.system.globalSettings.emails.index,
  integrations_manage: null,
  rewards_manage: null,
  logs_view: null,
  edit_posts: null,
});

const GlobalSettingsPaths = Object.freeze([
  'users_manage',
  'sso_authentication',
  'policy_templates_manage',
  'fields_manage',
  'branding_manage',
  'custom_text_manage',
  'emails_manage',
  'integrations_manage',
  'rewards_manage',
  'logs_manage',
  'edit_posts',
]);

const GroupBudgetManagePaths = Object.freeze([
  'groups_budget_manage',
]);

const GroupManagePaths = Object.freeze([
  'groups_create',
  'segments_create',
  'groups_calendars',
  'enterprise_folders_view',
]);

const RootManagePaths = Object.freeze([
  'metrics_overview',
  ...GroupManagePaths,
  ...GroupBudgetManagePaths,
  'campaigns_create',
  'polls_create',
  'mentoring_interests_manage',
  ...GlobalSettingsPaths,
]);

export function resolveRootManagePath(permission) {
  const page = permission && RootManagePaths.find(page => permission[page] && NameToPathMap[page]);
  return page ? NameToPathMap[page] : null;
}
