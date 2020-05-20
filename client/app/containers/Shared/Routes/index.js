import React from 'react';
import { Route, Switch } from 'react-router';

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

    { /* Admin - Include - Poll */ }
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
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.index)} component={BrandingThemePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.theme)} component={BrandingThemePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.home)} component={BrandingHomePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.new)} component={SponsorCreatePage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.edit)} component={SponsorEditPage} />
    <BrandingLayout exact {...expandRoute(ROUTES.admin.system.branding.sponsors.index)} component={SponsorListPage} />

    { /* Admin - System - Logs */ }
    <AdminLayout exact {...expandRoute(ROUTES.admin.system.logs.index)} component={LogListPage} />
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
        <Route path={[...expandRouteIntoPathArray(ROUTES.user), ROUTES.group.pathPrefix, ROUTES.admin.pathPrefix]}>
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
                    <RouteWithProps path={ROUTES.group.resources.folders.new.path()}><FolderEditPage /></RouteWithProps>
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
                    <RouteWithProps exact path={ROUTES.group.news.social_links.new.path()}><SocialLinkCreatePage /></RouteWithProps>
                    {/* Social Link Edit */}
                    <RouteWithProps exact path={ROUTES.group.news.social_links.edit.path()}><SocialLinkEditPage /></RouteWithProps>

                    {/* Plan */}
                    <RouteWithProps path={ROUTES.group.plan.pathPrefix()}>
                      <GroupPlanLayout>
                        <SwitchWithProps>
                          {/* Outcomes */}
                          <RouteWithProps exact path={ROUTES.group.plan.outcomes.index.path()}><OutcomesPage /></RouteWithProps>
                          {/* Outcome Create */}
                          <RouteWithProps exact path={ROUTES.group.plan.outcomes.new.path()}><OutcomeCreatePage /></RouteWithProps>
                          {/* Outcome Edit */}
                          <RouteWithProps exact path={ROUTES.group.plan.outcomes.edit.path()}><OutcomeEditPage /></RouteWithProps>

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
