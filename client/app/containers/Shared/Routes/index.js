import React from 'react';
import { Switch } from 'react-router';

// Pages
import {
  UserLayout, GroupLayout, AdminLayout, SessionLayout, ErrorLayout, GlobalSettingsLayout, LoginPage, HomePage,
  UserGroupListPage, AdminGroupListPage, GroupCreatePage, GroupEditPage, SegmentListPage, SegmentPage, FieldsPage,
  UsersPage, UserCreatePage, UserEditPage, GroupHomePage, EventsPage, NewsFeedPage, OutcomesPage, EventPage,
  EventCreatePage, EventEditPage, GroupMessagePage, GroupMessageCreatePage, GroupMessageEditPage, OutcomeCreatePage,
  OutcomeEditPage, GroupMemberListPage, GroupMemberCreatePage, NotFoundPage, PlaceholderPage, GroupDashboardPage,
  UserDashboardPage, MetricsDashboardListPage, MetricsDashboardCreatePage, MetricsDashboardEditPage, MetricsDashboardPage,
  CustomGraphCreatePage, CustomGraphEditPage, CustomTextEditPage
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
      <UserLayout exact {...expandRoute(ROUTES.user.home)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.innovate)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.news)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.events)} component={PlaceholderPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.groups)} component={UserGroupListPage} />
      <UserLayout exact {...expandRoute(ROUTES.user.downloads)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.mentorship)} component={PlaceholderPage} />

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
      <AdminLayout {...expandRoute(ROUTES.admin.manage.segments.show)} component={SegmentPage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.segments.index)} component={SegmentListPage} />

      { /* Admin - System - GlobalSettings */ }
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.fields.index)} component={FieldsPage} />
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.customText.edit)} component={CustomTextEditPage} />

      { /* Admin - System - Users */ }
      <AdminLayout exact {...expandRoute(ROUTES.admin.system.users.index)} component={UsersPage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.system.users.new)} component={UserCreatePage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.system.users.edit)} component={UserEditPage} />

      { /* Group */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.home)} component={GroupHomePage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.members.index)} component={GroupMemberListPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.index)} component={EventsPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.outcomes.index)} component={OutcomesPage} />

      { /* Group Events */ }
      <GroupLayout {...expandRoute(ROUTES.group.events.new)} component={EventCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.events.edit)} component={EventEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.events.show)} component={EventPage} />

      { /* Group News Feed */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.new)} component={GroupMessageCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.edit)} component={GroupMessageEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.messages.index)} component={GroupMessagePage} />

      { /* Group Members */ }
      <GroupLayout {...expandRoute(ROUTES.group.members.new)} component={GroupMemberCreatePage} />

      { /* Group Outcomes */ }
      <GroupLayout {...expandRoute(ROUTES.group.outcomes.new)} component={OutcomeCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.outcomes.edit)} component={OutcomeEditPage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
