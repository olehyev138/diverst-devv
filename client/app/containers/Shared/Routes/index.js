import React from 'react';
import { Route, Switch } from 'react-router-dom';

// Pages
import {
  ApplicationLayout,
  AuthenticatedLayout,
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
  PollShowPage,
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
  LogListPage,
  GroupSponsorsListPage,
  GroupSponsorsCreatePage,
  GroupSponsorsEditPage,
} from './templates';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

import RouteWithProps from 'components/Shared/Routes/RouteWithProps';
import SwitchWithProps from 'components/Shared/Routes/SwitchWithProps';

import { expandRouteIntoPathArray } from 'utils/routeHelpers';

const expandRoute = route => ({ path: route.path(), data: route.data || {} });

const oldRoutes = () => (
  <Switch>
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
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.index)} component={BrandingThemePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.theme)} component={BrandingThemePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.home)} component={BrandingHomePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.new)} component={SponsorCreatePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.edit)} component={SponsorEditPage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.index)} component={SponsorListPage} />
  </Switch>
);

export default function Routes(props) {
  return (
    <ApplicationLayout>
      <Switch>
        {/* Session */}
        <Route path={expandRouteIntoPathArray(ROUTES.session)}>
          <SessionLayout>
            <SwitchWithProps>
              {/* Login */}
              <RouteWithProps path={ROUTES.session.login.path()}><LoginPage /></RouteWithProps>
              {/* Forgot password */}
              <RouteWithProps path={ROUTES.session.forgotPassword.path()}><ForgotPasswordPage /></RouteWithProps>
              {/* Sign up */}
              <RouteWithProps path={ROUTES.session.signUp.path()}><SignUpPage /></RouteWithProps>
            </SwitchWithProps>
          </SessionLayout>
        </Route>

        {/* Authenticated */}
        <Route path={[...expandRouteIntoPathArray(ROUTES.user), ROUTES.group.pathPrefix(), ROUTES.admin.pathPrefix]}>
          <AuthenticatedLayout>
            <Switch>
              {/* User */}
              <Route exact path={expandRouteIntoPathArray(ROUTES.user)}>
                <UserLayout>
                  <SwitchWithProps>
                    {/* Home */}
                    <RouteWithProps exact path={ROUTES.user.home.path()}><HomePage /></RouteWithProps>
                    {/* Innovate */}
                    <RouteWithProps exact path={ROUTES.user.innovate.path()}><PlaceholderPage /></RouteWithProps>
                    {/* News */}
                    <RouteWithProps exact path={ROUTES.user.news.path()}><UserNewsLinkPage /></RouteWithProps>
                    {/* Events */}
                    <RouteWithProps exact path={ROUTES.user.events.path()}><UserEventsPage /></RouteWithProps>
                    {/* Groups */}
                    <RouteWithProps exact path={ROUTES.user.groups.path()}><UserGroupListPage /></RouteWithProps>
                    {/* Downloads */}
                    <RouteWithProps exact path={ROUTES.user.downloads.path()}><UserDownloadsPage /></RouteWithProps>

                    {/* Profile Edit */}
                    <RouteWithProps path={ROUTES.user.edit.path()}><UserEditPage /></RouteWithProps>
                    {/* Profile */}
                    <RouteWithProps path={ROUTES.user.show.path()}><UserProfilePage /></RouteWithProps>

                    {/* Mentorship */}
                    <RouteWithProps path={ROUTES.user.mentorship.pathPrefix}>
                      <MentorshipLayout>
                        <SwitchWithProps>
                          {/* Profile Edit */}
                          <RouteWithProps path={ROUTES.user.mentorship.edit.path()}><MentorshipEditProfilePage /></RouteWithProps>

                          {/* Mentors */}
                          <RouteWithProps path={ROUTES.user.mentorship.mentors.path()}><MentorsPage /></RouteWithProps>
                          {/* Mentees */}
                          <RouteWithProps path={ROUTES.user.mentorship.mentees.path()}><MentorsPage /></RouteWithProps>

                          {/* Proposals */}
                          <RouteWithProps path={ROUTES.user.mentorship.proposals.path()}><MentorRequestsPage /></RouteWithProps>
                          {/* Requests */}
                          <RouteWithProps path={ROUTES.user.mentorship.requests.path()}><MentorRequestsPage /></RouteWithProps>

                          {/* Session Schedule */}
                          <RouteWithProps path={ROUTES.user.mentorship.sessions.schedule.path()}><SessionsEditPage /></RouteWithProps>
                          {/* Session Edit */}
                          <RouteWithProps path={ROUTES.user.mentorship.sessions.edit.path()}><SessionsEditPage /></RouteWithProps>

                          {/* Session Hosting */}
                          <RouteWithProps path={ROUTES.user.mentorship.sessions.hosting.path()}><SessionsPage /></RouteWithProps>
                          {/* Session Participating */}
                          <RouteWithProps path={ROUTES.user.mentorship.sessions.participating.path()}><SessionsPage /></RouteWithProps>

                          {/* Session Show */}
                          <RouteWithProps path={ROUTES.user.mentorship.sessions.show.path()}><SessionPage /></RouteWithProps>

                          {/* Profile */}
                          <RouteWithProps path={ROUTES.user.mentorship.show.path()}><MentorshipProfilePage /></RouteWithProps>
                          {/* Profile */}
                          <RouteWithProps path={ROUTES.user.mentorship.home.path()}><MentorshipProfilePage /></RouteWithProps>
                        </SwitchWithProps>
                      </MentorshipLayout>
                    </RouteWithProps>
                  </SwitchWithProps>
                </UserLayout>
              </Route>

              {/* Group */}
              <Route path={ROUTES.group.pathPrefix()}>
                <GroupLayout>
                  <SwitchWithProps>
                    {/* Home */}
                    <RouteWithProps exact path={ROUTES.group.home.path()}><GroupHomePage /></RouteWithProps>

                    {/* Members */}
                    <RouteWithProps exact path={ROUTES.group.members.index.path()}><GroupMemberListPage /></RouteWithProps>
                    {/* Member Create */}
                    <RouteWithProps path={ROUTES.group.members.new.path()}><GroupMemberCreatePage /></RouteWithProps>

                    {/* Events */}
                    <RouteWithProps exact path={ROUTES.group.events.index.path()}><EventsPage /></RouteWithProps>
                    {/* Event Create */}
                    <RouteWithProps path={ROUTES.group.events.new.path()}><EventCreatePage /></RouteWithProps>
                    {/* Event Edit */}
                    <RouteWithProps path={ROUTES.group.events.edit.path()}><EventEditPage /></RouteWithProps>
                    {/* Event Show */}
                    <RouteWithProps exact path={ROUTES.group.events.show.path()}><EventPage /></RouteWithProps>

                    {/* Resources */}
                    <RouteWithProps exact path={ROUTES.group.resources.index.path()}><FoldersPage /></RouteWithProps>
                    {/* Resource Create */}
                    <RouteWithProps path={ROUTES.group.resources.new.path()}><ResourceCreatePage /></RouteWithProps>
                    {/* Resource Edit */}
                    <RouteWithProps path={ROUTES.group.resources.edit.path()}><ResourceEditPage /></RouteWithProps>
                    {/* Folder Create */}
                    <RouteWithProps path={ROUTES.group.resources.folders.new.path()}><FolderCreatePage /></RouteWithProps>
                    {/* Folder Edit */}
                    <RouteWithProps path={ROUTES.group.resources.folders.edit.path()}><FolderEditPage /></RouteWithProps>
                    {/* Folder Show */}
                    <RouteWithProps exact path={ROUTES.group.resources.folders.show.path()}><FolderPage /></RouteWithProps>

                    {/* News */}
                    <RouteWithProps exact path={ROUTES.group.news.index.path()}><NewsFeedPage /></RouteWithProps>
                    {/* Group Message Create */}
                    <RouteWithProps path={ROUTES.group.news.messages.new.path()}><GroupMessageCreatePage /></RouteWithProps>
                    {/* Group Message Edit */}
                    <RouteWithProps path={ROUTES.group.news.messages.edit.path()}><GroupMessageEditPage /></RouteWithProps>
                    {/* Group Message Show */}
                    <RouteWithProps exact path={ROUTES.group.news.messages.show.path()}><GroupMessagePage /></RouteWithProps>
                    {/* News Link Create */}
                    <RouteWithProps path={ROUTES.group.news.news_links.new.path()}><NewsLinkCreatePage /></RouteWithProps>
                    {/* News Link Edit */}
                    <RouteWithProps path={ROUTES.group.news.news_links.edit.path()}><NewsLinkEditPage /></RouteWithProps>
                    {/* News Link Show */}
                    <RouteWithProps exact path={ROUTES.group.news.news_links.show.path()}><NewsLinkPage /></RouteWithProps>
                    {/* Social Link Create */}
                    <RouteWithProps path={ROUTES.group.news.social_links.new.path()}><SocialLinkCreatePage /></RouteWithProps>
                    {/* Social Link Edit */}
                    <RouteWithProps path={ROUTES.group.news.social_links.edit.path()}><SocialLinkEditPage /></RouteWithProps>

                    {/* Plan */}
                    <RouteWithProps path={ROUTES.group.plan.pathPrefix()}>
                      <GroupPlanLayout>
                        <SwitchWithProps>
                          {/* Outcomes */}
                          <RouteWithProps exact path={ROUTES.group.plan.outcomes.index.path()}><OutcomesPage /></RouteWithProps>
                          {/* Outcome Create */}
                          <RouteWithProps path={ROUTES.group.plan.outcomes.new.path()}><OutcomeCreatePage /></RouteWithProps>
                          {/* Outcome Edit */}
                          <RouteWithProps path={ROUTES.group.plan.outcomes.edit.path()}><OutcomeEditPage /></RouteWithProps>

                          {/* Events */}
                          <RouteWithProps exact path={ROUTES.group.plan.events.index.path()}><GroupPlanEventsPage /></RouteWithProps>
                          {/* Event Manage */}
                          <RouteWithProps path={ROUTES.group.plan.events.manage.pathPrefix()}>
                            <EventManageLayout>
                              <SwitchWithProps>
                                {/* Metrics */}
                                <RouteWithProps path={ROUTES.group.plan.events.manage.metrics.path()}><EventManageMetricsPage /></RouteWithProps>
                                {/* Fields */}
                                <RouteWithProps path={ROUTES.group.plan.events.manage.fields.path()}><EventManageFieldsPage /></RouteWithProps>

                                {/* Updates */}
                                <RouteWithProps exact path={ROUTES.group.plan.events.manage.updates.index.path()}><EventManageUpdatesPage /></RouteWithProps>
                                {/* Update Create */}
                                <RouteWithProps path={ROUTES.group.plan.events.manage.updates.new.path()}><EventManageUpdateCreatePage /></RouteWithProps>
                                {/* Update Edit */}
                                <RouteWithProps path={ROUTES.group.plan.events.manage.updates.edit.path()}><EventManageUpdateEditPage /></RouteWithProps>
                                {/* Update Show */}
                                <RouteWithProps exact path={ROUTES.group.plan.events.manage.updates.show.path()}><EventManageUpdatePage /></RouteWithProps>

                                {/* Expenses */}
                                <RouteWithProps exact path={ROUTES.group.plan.events.manage.expenses.index.path()}><EventManageExpensesPage /></RouteWithProps>
                                {/* Expense Create */}
                                <RouteWithProps path={ROUTES.group.plan.events.manage.expenses.new.path()}><EventManageExpenseCreatePage /></RouteWithProps>
                                {/* Expense Edit */}
                                <RouteWithProps path={ROUTES.group.plan.events.manage.expenses.edit.path()}><EventManageExpenseEditPage /></RouteWithProps>
                              </SwitchWithProps>
                            </EventManageLayout>
                          </RouteWithProps>

                          {/* KPI */}
                          <RouteWithProps path={ROUTES.group.plan.kpi.pathPrefix()}>
                            <GroupKPILayout>
                              <SwitchWithProps>
                                {/* Metrics */}
                                <RouteWithProps path={ROUTES.group.plan.kpi.metrics.path()}><GroupPlanKpiPage /></RouteWithProps>
                                {/* Fields */}
                                <RouteWithProps path={ROUTES.group.plan.kpi.fields.path()}><GroupPlanFieldsPage /></RouteWithProps>
                                {/* Updates */}
                                <RouteWithProps exact path={ROUTES.group.plan.kpi.updates.index.path()}><GroupPlanUpdatesPage /></RouteWithProps>
                                {/* Update Create */}
                                <RouteWithProps path={ROUTES.group.plan.kpi.updates.new.path()}><GroupPlanUpdateCreatePage /></RouteWithProps>
                                {/* Update Edit */}
                                <RouteWithProps path={ROUTES.group.plan.kpi.updates.edit.path()}><GroupPlanUpdateEditPage /></RouteWithProps>
                                {/* Update Show */}
                                <RouteWithProps exact path={ROUTES.group.plan.kpi.updates.show.path()}><GroupPlanUpdatePage /></RouteWithProps>
                              </SwitchWithProps>
                            </GroupKPILayout>
                          </RouteWithProps>

                          {/* Budgets */}
                          <RouteWithProps exact path={ROUTES.group.plan.budget.budgets.index.path()}><BudgetsPage /></RouteWithProps>
                          {/* Budget Create */}
                          <RouteWithProps path={ROUTES.group.plan.budget.budgets.new.path()}><BudgetRequestPage /></RouteWithProps>
                          {/* Budget Show */}
                          <RouteWithProps path={ROUTES.group.plan.budget.budgets.show.path()}><BudgetPage /></RouteWithProps>
                          {/* Annual Budgets */}
                          <RouteWithProps path={ROUTES.group.plan.budget.pathPrefix()}>
                            <GroupBudgetLayout>
                              <SwitchWithProps>
                                {/* Edit */}
                                <RouteWithProps exact path={ROUTES.group.plan.budget.editAnnualBudget.path()}><AnnualBudgetEditPage /></RouteWithProps>
                                {/* Overview */}
                                <RouteWithProps exact path={ROUTES.group.plan.budget.overview.path()}><AnnualBudgetsPage /></RouteWithProps>
                              </SwitchWithProps>
                            </GroupBudgetLayout>
                          </RouteWithProps>
                        </SwitchWithProps>
                      </GroupPlanLayout>
                    </RouteWithProps>

                    {/* Manage */}
                    <RouteWithProps path={ROUTES.group.manage.pathPrefix()}>
                      <GroupManageLayout>
                        <SwitchWithProps>
                          {/* Settings */}
                          <RouteWithProps path={ROUTES.group.manage.settings.index.path()}><GroupSettingsPage /></RouteWithProps>

                          {/* Sponsors */}
                          <RouteWithProps exact path={ROUTES.group.manage.sponsors.index.path()}><GroupSponsorsListPage /></RouteWithProps>
                          {/* Sponsor Create */}
                          <RouteWithProps path={ROUTES.group.manage.sponsors.new.path()}><GroupSponsorsCreatePage /></RouteWithProps>
                          {/* Sponsor Edit */}
                          <RouteWithProps path={ROUTES.group.manage.sponsors.edit.path()}><GroupSponsorsEditPage /></RouteWithProps>

                          {/* Leaders */}
                          <RouteWithProps exact path={ROUTES.group.manage.leaders.index.path()}><GroupLeadersListPage /></RouteWithProps>
                          {/* Leader Create */}
                          <RouteWithProps path={ROUTES.group.manage.leaders.new.path()}><GroupLeaderCreatePage /></RouteWithProps>
                          {/* Leader Edit */}
                          <RouteWithProps path={ROUTES.group.manage.leaders.edit.path()}><GroupLeaderEditPage /></RouteWithProps>
                        </SwitchWithProps>
                      </GroupManageLayout>
                    </RouteWithProps>
                  </SwitchWithProps>
                </GroupLayout>
              </Route>

              {/* Admin */}
              <Route path={ROUTES.admin.pathPrefix}>
                <AdminLayout>
                  <SwitchWithProps>
                    { /* Analyze - Overview */ }
                    <RouteWithProps exact path={ROUTES.admin.analyze.overview.path()}><PlaceholderPage /></RouteWithProps>
                    { /* Analyze - Users */ }
                    <RouteWithProps path={ROUTES.admin.analyze.users.path()}><UserDashboardPage /></RouteWithProps>
                    { /* Analyze - Groups */ }
                    <RouteWithProps path={ROUTES.admin.analyze.groups.path()}><GroupDashboardPage /></RouteWithProps>

                    { /* Analyze - Custom */ }
                    <RouteWithProps exact path={ROUTES.admin.analyze.custom.index.path()}><MetricsDashboardListPage /></RouteWithProps>
                    { /* Analyze - Custom Edit */ }
                    <RouteWithProps path={ROUTES.admin.analyze.custom.edit.path()}><MetricsDashboardEditPage /></RouteWithProps>
                    { /* Analyze - Custom Create */ }
                    <RouteWithProps path={ROUTES.admin.analyze.custom.new.path()}><MetricsDashboardCreatePage /></RouteWithProps>
                    { /* Analyze - Custom Show */ }
                    <RouteWithProps path={ROUTES.admin.analyze.custom.show.path()}><MetricsDashboardPage /></RouteWithProps>
                    { /* Analyze - Custom - Graphs - New */ }
                    <RouteWithProps path={ROUTES.admin.analyze.custom.graphs.new.path()}><CustomGraphCreatePage /></RouteWithProps>
                    { /* Analyze - Custom - Graphs - Edit */ }
                    <RouteWithProps path={ROUTES.admin.analyze.custom.graphs.edit.path()}><CustomGraphEditPage /></RouteWithProps>

                    { /* Manage - Groups */ }
                    <RouteWithProps exact path={ROUTES.admin.manage.groups.index.path()}><AdminGroupListPage /></RouteWithProps>
                    { /* Manage - Group Create */ }
                    <RouteWithProps path={ROUTES.admin.manage.groups.new.path()}><GroupCreatePage /></RouteWithProps>
                    { /* Manage - Group Edit */ }
                    <RouteWithProps path={ROUTES.admin.manage.groups.edit.path()}><GroupEditPage /></RouteWithProps>

                    { /* Manage - Group Categories */ }
                    <RouteWithProps exact path={ROUTES.admin.manage.groups.categories.index.path()}><GroupCategoriesPage /></RouteWithProps>
                    { /* Manage - Group Category Create */ }
                    <RouteWithProps path={ROUTES.admin.manage.groups.categories.new.path()}><GroupCategoriesCreatePage /></RouteWithProps>
                    { /* Manage - Group Category Edit */ }
                    <RouteWithProps path={ROUTES.admin.manage.groups.categories.edit.path()}><GroupCategoriesEditPage /></RouteWithProps>
                    { /* Manage - Group Categorize */ }
                    <RouteWithProps path={ROUTES.admin.manage.groups.categorize.path()}><GroupCategorizePage /></RouteWithProps>

                    { /* Manage - Segments */ }
                    <RouteWithProps exact path={ROUTES.admin.manage.segments.index.path()}><SegmentListPage /></RouteWithProps>
                    { /* Manage - Segment Create */ }
                    <RouteWithProps path={ROUTES.admin.manage.segments.new.path()}><SegmentPage /></RouteWithProps>
                    { /* Manage - Segment Show */ }
                    <RouteWithProps path={ROUTES.admin.manage.segments.show.path()}><SegmentPage /></RouteWithProps>

                    { /* Manage - Resources */ }
                    <RouteWithProps exact path={ROUTES.admin.manage.resources.index.path()}><EFoldersPage /></RouteWithProps>
                    { /* Manage - Resources (Archived) */ }
                    <RouteWithProps exact path={ROUTES.admin.manage.archived.index.path()}><ArchivesPage /></RouteWithProps>
                    { /* Manage - Resource Create */ }
                    <RouteWithProps path={ROUTES.admin.manage.resources.new.path()}><EResourceCreatePage /></RouteWithProps>
                    { /* Manage - Resource Edit */ }
                    <RouteWithProps path={ROUTES.admin.manage.resources.edit.path()}><EResourceEditPage /></RouteWithProps>
                    { /* Manage - Folder Create */ }
                    <RouteWithProps path={ROUTES.admin.manage.resources.folders.new.path()}><EFolderCreatePage /></RouteWithProps>
                    { /* Manage - Folder Edit */ }
                    <RouteWithProps path={ROUTES.admin.manage.resources.folders.edit.path()}><EFolderEditPage /></RouteWithProps>
                    { /* Manage - Folder Show */ }
                    <RouteWithProps path={ROUTES.admin.manage.resources.folders.show.path()}><EFolderPage /></RouteWithProps>

                    { /* Plan - Budget */ }
                    <RouteWithProps path={ROUTES.admin.plan.budgeting.index.path()}><AdminAnnualBudgetPage /></RouteWithProps>

                    { /* Polls */ }
                    <RouteWithProps exact path={ROUTES.admin.include.polls.index.path()}><PollsList /></RouteWithProps>
                    { /* Poll Create */ }
                    <RouteWithProps path={ROUTES.admin.include.polls.new.path()}><PollCreatePage /></RouteWithProps>
                    { /* Poll Edit */ }
                    <RouteWithProps path={ROUTES.admin.include.polls.edit.path()}><PollEditPage /></RouteWithProps>
                    { /* Poll Show */ }
                    <RouteWithProps path={ROUTES.admin.include.polls.show.path()}><PollShowPage /></RouteWithProps>

                    { /* Innovate - Campaigns */ }
                    <RouteWithProps exact path={ROUTES.admin.innovate.campaigns.index.path()}><CampaignListPage /></RouteWithProps>
                    { /* Innovate - Campaign Create */ }
                    <RouteWithProps path={ROUTES.admin.innovate.campaigns.new.path()}><CampaignCreatePage /></RouteWithProps>
                    { /* Innovate - Campaign Edit */ }
                    <RouteWithProps path={ROUTES.admin.innovate.campaigns.edit.path()}><CampaignEditPage /></RouteWithProps>
                    { /* Innovate - Campaign Show */ }
                    <RouteWithProps path={ROUTES.admin.innovate.campaigns.show.path()}><CampaignShowPage /></RouteWithProps>
                    { /* Innovate - Campaign - Question Create */ }
                    <RouteWithProps path={ROUTES.admin.innovate.campaigns.questions.new.path()}><CampaignQuestionCreatePage /></RouteWithProps>
                    { /* Innovate - Campaign - Question Edit */ }
                    <RouteWithProps path={ROUTES.admin.innovate.campaigns.questions.edit.path()}><CampaignQuestionEditPage /></RouteWithProps>
                    { /* Innovate - Campaign - Question Show */ }
                    <RouteWithProps path={ROUTES.admin.innovate.campaigns.questions.show.path()}><CampaignQuestionShowPage /></RouteWithProps>

                    { /* Innovate - Financials */ }
                    <RouteWithProps exact path={ROUTES.admin.innovate.financials.index.path()}><PlaceholderPage /></RouteWithProps>

                    { /* System - Global Settings */ }
                    <RouteWithProps path={ROUTES.admin.system.globalSettings.pathPrefix}>
                      <GlobalSettingsLayout>
                        <Switch>
                          { /* Fields */}
                          <RouteWithProps exact path={ROUTES.admin.system.globalSettings.fields.index.path()}><FieldsPage /></RouteWithProps>
                          { /* Custom Text Edit */}
                          <RouteWithProps exact path={ROUTES.admin.system.globalSettings.customText.edit.path()}><CustomTextEditPage /></RouteWithProps>
                          { /* Enterprise Configuration */}
                          <RouteWithProps exact path={ROUTES.admin.system.globalSettings.enterpriseConfiguration.index.path()}><EnterpriseConfigurationPage /></RouteWithProps>
                          { /* SSO Settings */}
                          <RouteWithProps exact path={ROUTES.admin.system.globalSettings.ssoSettings.edit.path()}><SSOSettingsPage /></RouteWithProps>

                          { /* Emails */}
                          <RouteWithProps path={ROUTES.admin.system.globalSettings.emails.pathPrefix}>
                            <EmailLayout>
                              <Switch>
                                { /* Emails */}
                                <RouteWithProps exact path={ROUTES.admin.system.globalSettings.emails.index.path()}><EmailsPage /></RouteWithProps>
                                { /* Email Edit */}
                                <RouteWithProps exact path={ROUTES.admin.system.globalSettings.emails.edit.path()}><EmailEditPage /></RouteWithProps>

                                { /* Email Events */}
                                <RouteWithProps exact path={ROUTES.admin.system.globalSettings.mailEvents.index.path()}><EmailEventsPage /></RouteWithProps>
                                { /* Email Event Edit */}
                                <RouteWithProps exact path={ROUTES.admin.system.globalSettings.mailEvents.edit.path()}><EmailEventEditPage /></RouteWithProps>
                              </Switch>
                            </EmailLayout>
                          </RouteWithProps>
                        </Switch>
                      </GlobalSettingsLayout>
                    </RouteWithProps>

                    { /* System - Logs */ }
                    <RouteWithProps exact path={ROUTES.admin.system.logs.index.path()}><LogListPage /></RouteWithProps>
                  </SwitchWithProps>
                </AdminLayout>
              </Route>
            </Switch>
          </AuthenticatedLayout>
        </Route>

        {/* Error */}
        <Route>
          <ErrorLayout>
            <NotFoundPage />
          </ErrorLayout>
        </Route>
      </Switch>
    </ApplicationLayout>
  );
}
