import React from 'react';
import { Switch } from 'react-router';
import PropTypes from 'prop-types';

// Layouts
import UserLayout from 'containers/Layouts/UserLayout/index';
import GroupLayout from 'containers/Layouts/GroupLayout/index';
import AdminLayout from 'containers/Layouts/AdminLayout/index';
import SessionLayout from 'containers/Layouts/SessionLayout/index';
import ErrorLayout from 'containers/Layouts/ErrorLayout/index';

// Pages
import {
  HomePage, LoginPage, NotFoundPage, PlaceholderPage
} from 'containers/Shared/Routes/templates';

/* Admin - Manage - Group */
import UserGroupListPage from 'containers/Group/UserGroupListPage';
import AdminGroupListPage from 'containers/Group/AdminGroupListPage';
import GroupCreatePage from 'containers/Group/GroupCreatePage';
import GroupEditPage from 'containers/Group/GroupEditPage';

/* Group */
import GroupHomePage from 'containers/Group/GroupHomePage';
import NewsFeedPage from 'containers/News/NewsFeedPage';

/* Group - News Feed */
import GroupMessagePage from 'containers/News/GroupMessage/GroupMessagePage';
import GroupMessageCreatePage from 'containers/News/GroupMessage/GroupMessageCreatePage';
import GroupMessageEditPage from 'containers/News/GroupMessage/GroupMessageEditPage';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  const expandRoute = route => ({ path: route.path(), data: route.data || {} });

  return (
    <Switch>
      <SessionLayout {...expandRoute(ROUTES.session.login)} component={LoginPage} />

      { /* Admin */ }
      { /* Admin - Analyze */ }
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.overview)} component={PlaceholderPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.analyze.users)} component={PlaceholderPage} />

      { /* Admin - Manage */ }
      { /* Admin - Manage - Groups */ }
      <AdminLayout exact {...expandRoute(ROUTES.admin.manage.groups.index)} component={AdminGroupListPage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.new)} component={GroupCreatePage} />
      <AdminLayout {...expandRoute(ROUTES.admin.manage.groups.edit)} component={GroupEditPage} />

      <UserLayout exact {...expandRoute(ROUTES.user.home)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.innovate)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.innovate)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.news)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.events)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.groups)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.downloads)} component={PlaceholderPage} />
      <UserLayout {...expandRoute(ROUTES.user.mentorship)} component={PlaceholderPage} />

      { /* Group */ }
      <GroupLayout exact {...expandRoute(ROUTES.group.home)} component={GroupHomePage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.index)} component={NewsFeedPage} />

      { /* Group News Feed */ }
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.new)} component={GroupMessageCreatePage} />
      <GroupLayout {...expandRoute(ROUTES.group.news.messages.edit)} component={GroupMessageEditPage} />
      <GroupLayout exact {...expandRoute(ROUTES.group.news.messages.index)} component={GroupMessagePage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
