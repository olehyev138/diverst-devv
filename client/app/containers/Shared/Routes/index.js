import React from 'react';
import { Switch } from 'react-router';

// Pages
import {
  SignUpPage,
  UserLayout,
  GroupLayout,
  AdminLayout,
  SessionLayout,
  ErrorLayout,
  GlobalSettingsLayout,
  LoginPage,
  ForgotPasswordPage,
  HomePage,
  UserGroupListPage,
  AdminGroupListPage,
  GroupCreatePage,
  GroupEditPage,
  GroupCategoriesPage,
  GroupCategoriesCreatePage,
  GroupCategoriesEditPage,
  GroupCategorizePage,
  SegmentListPage,
  SegmentPage,
  FieldsPage,
  UsersPage,
  UsersImportPage,
  UserCreatePage,
  UserEditPage,
  GroupHomePage,
  EventsPage,
  NewsFeedPage,
  EventPage,
  EventCreatePage,
  EventEditPage,
  EventManageMetricsPage,
  GroupPlanEventsPage,
  GroupMessagePage,
  GroupMessageCreatePage,
  GroupMessageEditPage,
  GroupPlanUpdateCreatePage,
  OutcomesPage,
  OutcomeCreatePage,
  OutcomeEditPage,
  GroupPlanLayout,
  GroupKPILayout,
  GroupBudgetLayout,
  GroupPlanKpiPage,
  GroupPlanFieldsPage,
  GroupPlanUpdatesPage,
  GroupPlanUpdatePage,
  EventManageLayout,
  EventManageFieldsPage,
  EventManageUpdatesPage,
  EventManageUpdatePage,
  EventManageUpdateEditPage,
  EventManageUpdateCreatePage,
  EventManageExpensesPage,
  EventManageExpenseCreatePage,
  EventManageExpenseEditPage,
  GroupPlanUpdateEditPage,
  GroupMemberListPage,
  GroupMemberCreatePage,
  NotFoundPage,
  PlaceholderPage,
  GroupDashboardPage,
  UserDashboardPage,
  MetricsDashboardListPage,
  MetricsDashboardCreatePage,
  MetricsDashboardEditPage,
  MetricsDashboardPage,
  CustomGraphCreatePage,
  CustomGraphEditPage,
  GroupManageLayout,
  GroupLeadersListPage,
  GroupLeaderCreatePage,
  GroupLeaderEditPage,
  AdminAnnualBudgetPage,
  AnnualBudgetEditPage,
  AnnualBudgetsPage,
  BudgetsPage,
  BudgetPage,
  BudgetRequestPage,
  GroupSettingsPage,
  CustomTextEditPage,
  UserNewsLinkPage,
  UserEventsPage,
  FoldersPage,
  FolderCreatePage,
  FolderEditPage,
  FolderPage,
  ResourceCreatePage,
  ResourceEditPage,
  EFoldersPage,
  EFolderCreatePage,
  EFolderEditPage,
  EFolderPage,
  EResourceCreatePage,
  EResourceEditPage,
  UserProfilePage,
  InnovateLayout,
  CampaignListPage,
  CampaignCreatePage,
  CampaignEditPage,
  CampaignShowPage,
  CampaignQuestionListPage,
  CampaignQuestionCreatePage,
  CampaignQuestionEditPage,
  PollsList,
  PollCreatePage,
  PollEditPage,
  EnterpriseConfigurationPage,
  MentorshipProfilePage,
  MentorshipEditProfilePage,
  MentorshipLayout,
  MentorsPage,
  MentorRequestsPage,
  SessionsPage,
  SessionPage,
  SessionsEditPage,
  SystemUserLayout,
  UserRolesListPage,
  UserRoleCreatePage,
  UserRoleEditPage,
  BrandingLayout,
  BrandingThemePage,
  BrandingHomePage,
  SponsorListPage,
  SponsorCreatePage,
  SponsorEditPage,
  CampaignQuestionShowPage,
  SSOSettingsPage,
  EmailsPage,
  EmailEditPage,
  EmailEventsPage,
  EmailEventEditPage,
  EmailLayout,
  PolicyTemplatesPage,
  PolicyTemplateEditPage,
  NewsLinkCreatePage,
  NewsLinkEditPage,
  NewsLinkPage,
  SocialLinkCreatePage,
  SocialLinkEditPage,
  UserDownloadsPage,
  ArchivesPage,
  GroupSponsorsListPage,
  GroupSponsorsCreatePage, GroupSponsorsEditPage
} from './templates';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  const expandRoute = route => ({ path: route.path(), data: route.data || {} });

  return (
    <Switch>
      { /* Session */ }
      <SessionLayout {...expandRoute(ROUTES.session.login)} component={LoginPage} />
      <SessionLayout {...expandRoute(ROUTES.session.forgotPassword)} component={ForgotPasswordPage} />
      <SessionLayout {...expandRoute(ROUTES.session.sign_up)} component={SignUpPage} />

      { /* User */}
      <UserLayout exact {...expandRoute(ROUTES.user.home)} component={HomePage} />
      <UserLayout exact {...expandRoute(ROUTES.user.innovate)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.news)} component={UserNewsLinkPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.events)} component={UserEventsPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.groups)} component={UserGroupListPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.downloads)} component={UserDownloadsPage} />
      <UserLayout {...expandRoute(ROUTES.user.edit)} component={UserEditPage} />
      <UserLayout {...expandRoute(ROUTES.user.show)} component={UserProfilePage} disableBreadcrumbs />

      { /* User - Mentorship */ }
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.edit)} component={MentorshipEditProfilePage} disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.mentors)} component={MentorsPage} type='mentors' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.mentees)} component={MentorsPage} type='mentees' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.proposals)} component={MentorRequestsPage} type='outgoing' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.requests)} component={MentorRequestsPage} type='incoming' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.sessions.schedule)} component={SessionsEditPage} type='new' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.sessions.edit)} component={SessionsEditPage} type='edit' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.sessions.hosting)} component={SessionsPage} type='hosting' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.sessions.participating)} component={SessionsPage} type='participating' disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.sessions.show)} component={SessionPage} disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.show)} component={MentorshipProfilePage} disableBreadcrumbs />
      <MentorshipLayout {...expandRoute(ROUTES.user.mentorship.home)} component={MentorshipProfilePage} disableBreadcrumbs />

      { /* Admin */ }
      { /* Admin - Analyze */ }
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.users)} component={UserDashboardPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.groups)} component={GroupDashboardPage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.analyze.overview)} component={PlaceholderPage} />

      { /* Admin - Analyze - Custom */ }
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.custom.edit)} component={MetricsDashboardEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.custom.new)} component={MetricsDashboardCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.custom.graphs.new)} component={CustomGraphCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.custom.graphs.edit)} component={CustomGraphEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.custom.show)} component={MetricsDashboardPage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.analyze.custom.index)} component={MetricsDashboardListPage} />

      { /* Admin - Manage */ }
      { /* Admin - Manage - Groups */ }
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.new)} component={GroupCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.edit)} component={GroupEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.categorize)} component={GroupCategorizePage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.groups.index)} component={AdminGroupListPage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.groups.categories.index)} component={GroupCategoriesPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.categories.new)} component={GroupCategoriesCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.categories.edit)} component={GroupCategoriesEditPage} />

      { /* Admin - Manage - Segments */ }
      <AdminLayout {...expandRoute(ROUTES.admin.manage.segments.new)} component={SegmentPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.segments.show)} component={SegmentPage} edit />
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.segments.index)} component={SegmentListPage} />

      { /* Admin - Manage - Resources */ }
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.new)} component={EResourceCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.edit)} component={EResourceEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.edit)} component={EFolderEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.new)} component={EFolderCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.show)} component={EFolderPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.index)} component={EFoldersPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.archived.index)} component={ArchivesPage} />

      { /* Admin - Plan - Budget */ }
      <AdminLayout {...expandRoute(ROUTES.admin.plan.budgeting.index)} component={AdminAnnualBudgetPage} />

      { /* Admin - Plan - Budget */ }
      <AdminLayout {...expandRoute(ROUTES.admin.include.polls.new)} component={PollCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.include.polls.edit)} component={PollEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.include.polls.index)} component={PollsList} />

      { /* Admin - Innovate */ }
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.new)} component={CampaignCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.edit)} component={CampaignEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.questions.new)} component={CampaignQuestionCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.questions.edit)} component={CampaignQuestionEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.questions.show)} component={CampaignQuestionShowPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.show)} component={CampaignShowPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.index)} component={CampaignListPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.financials.index)} component={PlaceholderPage} />

      { /* Admin - System - GlobalSettings */ }
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.index)} defaultPage />
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.fields.index)} component={FieldsPage} />
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.customText.edit)} component={CustomTextEditPage} />
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.enterpriseConfiguration.index)} component={EnterpriseConfigurationPage} />
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.ssoSettings.edit)} component={SSOSettingsPage} />
      <EmailLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.emails.index)} component={EmailsPage} />
      <EmailLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.emails.edit)} component={EmailEditPage} />
      <EmailLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.mailEvents.index)} component={EmailEventsPage} />
      <EmailLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.mailEvents.edit)} component={EmailEventEditPage} />

      { /* Admin - System - Users */ }
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.index)} component={UsersPage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.import)} component={UsersImportPage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.new)} component={UserCreatePage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.edit)} component={UserEditPage} />

      { /* Admin - System - User Roles */ }
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.roles.index)} component={UserRolesListPage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.roles.new)} component={UserRoleCreatePage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.roles.edit)} component={UserRoleEditPage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.policy_templates.index)} component={PolicyTemplatesPage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.policy_templates.edit)} component={PolicyTemplateEditPage} />

      { /* Admin - System - Branding */ }
      <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.theme)} component={BrandingThemePage} />
      <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.home)} component={BrandingHomePage} />
      <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.new)} component={SponsorCreatePage} />
      <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.edit)} component={SponsorEditPage} />
      <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.index)} component={SponsorListPage} />

      { /* Group */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.home)} component={GroupHomePage} disableBreadcrumbs />
      <GroupLayout exact {...expandRoute(ROUTES.group.members.index)} component={GroupMemberListPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.index)} component={EventsPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />

      { /* Group Events */ }
      <GroupLayout {...expandRoute(ROUTES.group.events.new)} component={EventCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.events.edit)} component={EventEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.show)} component={EventPage} />

      { /* Group News Feed */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.new)} component={GroupMessageCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.edit)} component={GroupMessageEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.messages.show)} component={GroupMessagePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.news_links.new)} component={NewsLinkCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.news_links.edit)} component={NewsLinkEditPage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.news_links.show)} component={NewsLinkPage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.social_links.new)} component={SocialLinkCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.social_links.edit)} component={SocialLinkEditPage} />

      { /* Group Members */ }
      <GroupLayout {...expandRoute(ROUTES.group.members.new)} component={GroupMemberCreatePage} />

      { /* Group Plan */ }
      { /* Group Plan - Structure/Outcomes */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.plan.index)} component={GroupPlanLayout} defaultPage />
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.outcomes.index)} component={OutcomesPage} />
      <GroupPlanLayout {...expandRoute(ROUTES.group.plan.outcomes.new)} component={OutcomeCreatePage} />
      <GroupPlanLayout {...expandRoute(ROUTES.group.plan.outcomes.edit)} component={OutcomeEditPage} />

      { /* Group Plan - Events */ }
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.events.index)} component={GroupPlanEventsPage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.metrics)} component={EventManageMetricsPage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.fields)} component={EventManageFieldsPage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.updates.edit)} component={EventManageUpdateEditPage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.updates.new)} component={EventManageUpdateCreatePage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.updates.show)} component={EventManageUpdatePage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.updates.index)} component={EventManageUpdatesPage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.expenses.new)} component={EventManageExpenseCreatePage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.expenses.edit)} component={EventManageExpenseEditPage} />
      <EventManageLayout exact {...expandRoute(ROUTES.group.plan.events.manage.expenses.index)} component={EventManageExpensesPage} />

      { /* Group Plan - KPI */ }
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.metrics)} component={GroupPlanKpiPage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.fields)} component={GroupPlanFieldsPage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.updates.edit)} component={GroupPlanUpdateEditPage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.updates.new)} component={GroupPlanUpdateCreatePage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.updates.show)} component={GroupPlanUpdatePage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.updates.index)} component={GroupPlanUpdatesPage} />

      { /* Group Plan - Budget */ }
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.budget.index)} component={GroupBudgetLayout} defaultPage />
      <GroupBudgetLayout exact {...expandRoute(ROUTES.group.plan.budget.editAnnualBudget)} component={AnnualBudgetEditPage} />
      <GroupBudgetLayout exact {...expandRoute(ROUTES.group.plan.budget.overview)} component={AnnualBudgetsPage} />
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.budget.budgets.new)} component={BudgetRequestPage} />
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.budget.budgets.show)} component={BudgetPage} />
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.budget.budgets.index)} component={BudgetsPage} />

      { /* Group Manage */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.manage.index)} component={GroupManageLayout} defaultPage />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.settings.index)} component={GroupSettingsPage} />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.sponsors.new)} component={GroupSponsorsCreatePage} />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.sponsors.edit)} component={GroupSponsorsEditPage} />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.sponsors.index)} component={GroupSponsorsListPage} />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.leaders.new)} component={GroupLeaderCreatePage} />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.leaders.edit)} component={GroupLeaderEditPage} />
      <GroupManageLayout {...expandRoute(ROUTES.group.manage.leaders.index)} component={GroupLeadersListPage} />

      { /* Group Resources */ }
      <GroupLayout {...expandRoute(ROUTES.group.resources.new)} component={ResourceCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.resources.edit)} component={ResourceEditPage} />
      <GroupLayout {...expandRoute(ROUTES.group.resources.folders.edit)} component={FolderEditPage} />
      <GroupLayout {...expandRoute(ROUTES.group.resources.folders.new)} component={FolderCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.resources.folders.show)} component={FolderPage} />
      <GroupLayout {...expandRoute(ROUTES.group.resources.index)} component={FoldersPage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
