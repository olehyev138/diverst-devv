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
  CustomGraphCreatePage, CustomGraphEditPage, GroupManageLayout, GroupSettingsPage, CustomTextEditPage,
  UserNewsLinkPage, UserEventsPage, FoldersPage, FolderCreatePage, FolderEditPage, FolderPage, ResourceCreatePage,
  ResourceEditPage, UserProfilePage, InnovateLayout
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

      { /* Admin - Manage - Resources */ }
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.new)} component={ResourceCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.edit)} component={ResourceEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.edit)} component={FolderEditPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.new)} component={FolderCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.folders.show)} component={FolderPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.resources.index)} component={FoldersPage} />

      { /* Admin - Innovate */ }
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.campaigns.index)} component={PlaceholderPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.innovate.financials.index)} component={PlaceholderPage} />

      { /* Admin - System - GlobalSettings */ }
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.fields.index)} component={FieldsPage} />
      <GlobalSettingsLayout exact {...expandRoute(ROUTES.admin.system.globalSettings.customText.edit)} component={CustomTextEditPage} />

      { /* Admin - System - Users */ }
      <AdminLayout exact {...expandRoute(ROUTES.admin.system.users.index)} component={UsersPage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.system.users.new)} component={UserCreatePage} />
      <AdminLayout exact {...expandRoute(ROUTES.admin.system.users.edit)} component={UserEditPage} />

      { /* Group */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.home)} component={GroupHomePage} disableBreadcrumbs />
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
      <GroupLayout exact {...expandRoute(ROUTES.group.news.messages.show)} component={GroupMessagePage} />

      { /* Group Members */ }
      <GroupLayout {...expandRoute(ROUTES.group.members.new)} component={GroupMemberCreatePage} />

      { /* Group Outcomes */ }
      <GroupLayout {...expandRoute(ROUTES.group.outcomes.new)} component={OutcomeCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.outcomes.edit)} component={OutcomeEditPage} />

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
