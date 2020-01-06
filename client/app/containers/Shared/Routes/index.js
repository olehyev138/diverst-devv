import React from 'react';
import { Switch } from 'react-router';

// Pages
import {
  UserLayout,
  GroupLayout,
  AdminLayout,
  SessionLayout,
  ErrorLayout,
  GlobalSettingsLayout,
  LoginPage,
  HomePage,
  UserGroupListPage,
  AdminGroupListPage,
  GroupCreatePage,
  GroupEditPage,
  SegmentListPage,
  SegmentPage,
  FieldsPage,
  UsersPage,
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
  OutcomesPage,
  OutcomeCreatePage,
  OutcomeEditPage,
  GroupPlanLayout,
  GroupKPILayout,
  GroupPlanKpiPage,
  GroupPlanFieldsPage,
  GroupPlanUpdatesPage,
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
  UserProfilePage,
  InnovateLayout,
  CampaignListPage,
  CampaignCreatePage,
  CampaignEditPage,
  CampaignShowPage,
  CampaignQuestionListPage,
  CampaignQuestionCreatePage,
  CampaignQuestionEditPage,
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
  CampaignQuestionShowPage,
  SSOSettingsPage,
  EmailsPage,
  EmailEditPage,
  EmailEventsPage,
  EmailEventEditPage,
  EmailLayout,
  NewsLinkCreatePage,
  NewsLinkEditPage,
  NewsLinkPage,
  SocialLinkCreatePage,
  SocialLinkEditPage
} from './templates';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  const expandRoute = route => ({ path: route.path(), data: route.data || {} });

  return (
    <Switch>
      { /* Session */ }
      <SessionLayout {...expandRoute(ROUTES.session.login)} component={LoginPage} />

      { /* User */}
      <UserLayout exact {...expandRoute(ROUTES.user.home)} component={HomePage} />
      <UserLayout exact {...expandRoute(ROUTES.user.innovate)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.news)} component={UserNewsLinkPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.events)} component={UserEventsPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.groups)} component={UserGroupListPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.downloads)} component={PlaceholderPage} />
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
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.groups.index)} component={AdminGroupListPage} />

      { /* Admin - Manage - Segments */ }
      <AdminLayout {...expandRoute(ROUTES.admin.manage.segments.new)} component={SegmentPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.segments.show)} component={SegmentPage} edit />
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.segments.index)} component={SegmentListPage} />

      { /* Admin - Manage - Resources */ }
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.new)} component={ResourceCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.edit)} component={ResourceEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.edit)} component={FolderEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.new)} component={FolderCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.show)} component={FolderPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.index)} component={FoldersPage} />

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
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.new)} component={UserCreatePage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.edit)} component={UserEditPage} />

      { /* Admin - System - User Roles */ }
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.roles.index)} component={UserRolesListPage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.roles.new)} component={UserRoleCreatePage} />
      <SystemUserLayout exact {...expandRoute(ROUTES.admin.system.users.roles.edit)} component={UserRoleEditPage} />

      { /* Group */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.home)} component={GroupHomePage} disableBreadcrumbs />
      <GroupLayout exact {...expandRoute(ROUTES.group.members.index)} component={GroupMemberListPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.index)} component={EventsPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.plan.outcomes.index)} component={OutcomesPage} />

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
      <GroupLayout exact {...expandRoute(ROUTES.group.plan.outcomes.index)} component={OutcomesPage} />
      <GroupLayout {...expandRoute(ROUTES.group.plan.outcomes.new)} component={OutcomeCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.plan.outcomes.edit)} component={OutcomeEditPage} />

      { /* Group Plan - Events */ }
      <GroupPlanLayout exact {...expandRoute(ROUTES.group.plan.events.index)} component={GroupPlanEventsPage} />
      <GroupPlanLayout {...expandRoute(ROUTES.group.plan.events.manage.metrics)} component={EventManageMetricsPage} />

      { /* Group Plan - KPI */ }
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.metrics)} component={GroupPlanKpiPage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.fields)} component={GroupPlanFieldsPage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.updates.edit)} component={GroupPlanUpdateEditPage} />
      <GroupKPILayout exact {...expandRoute(ROUTES.group.plan.kpi.updates.index)} component={GroupPlanUpdatesPage} />

      { /* Group Manage */ }
      { /* TODO - redirect /manage -> /manage/settings */ }
      <GroupLayout {...expandRoute(ROUTES.group.manage.settings.index)} component={GroupSettingsPage} />
      <GroupLayout {...expandRoute(ROUTES.group.manage.leaders.index)} component={PlaceholderPage} />

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
