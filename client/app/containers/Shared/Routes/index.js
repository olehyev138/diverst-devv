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

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  return (
    <Switch>
      <SessionLayout path={ROUTES.session.login.path} component={LoginPage} />

      { /* Admin */ }
      { /* Admin - Analyze */ }
      <AdminLayout path={ROUTES.admin.analyze.overview.path} route={ROUTES.admin.analyze.overview} component={PlaceholderPage} />
      <AdminLayout path={ROUTES.admin.analyze.users.path} route={ROUTES.admin.analyze.users} component={PlaceholderPage} />

      { /* Admin - Manage */ }
      { /* Admin - Manage - Groups */ }
      <AdminLayout exact path={ROUTES.admin.manage.groups.index.path} route={ROUTES.admin.manage.groups.index} component={AdminGroupListPage} />
      <AdminLayout path={ROUTES.admin.manage.groups.new.path} route={ROUTES.admin.manage.groups.new} component={GroupCreatePage} />
      <AdminLayout path={ROUTES.admin.manage.groups.edit.path} route={ROUTES.admin.manage.groups.edit} component={GroupEditPage} />
      <AdminLayout path={ROUTES.admin.manage.groups.delete.path} route={ROUTES.admin.manage.groups.delete} component={PlaceholderPage} />

      <UserLayout exact path={ROUTES.user.home.path} route={ROUTES.user.home} pageTitle={ROUTES.user.home.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.innovate.path} route={ROUTES.user.innovate} pageTitle={ROUTES.user.innovate.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.news.path} route={ROUTES.user.news} pageTitle={ROUTES.user.news.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.events.path} route={ROUTES.user.events} pageTitle={ROUTES.user.events.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.groups.path} route={ROUTES.user.groups} pageTitle={ROUTES.user.groups.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.downloads.path} route={ROUTES.user.downloads} pageTitle={ROUTES.user.downloads.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.mentorship.path} route={ROUTES.user.mentorship} pageTitle={ROUTES.user.mentorship.titleMessage} component={PlaceholderPage} />

      { /* Group */ }
      <GroupLayout exact path={ROUTES.group.home.path} route={ROUTES.group.home} component={GroupHomePage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
