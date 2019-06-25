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

import UserGroupListPage from 'containers/Group/UserGroupListPage';
import AdminGroupListPage from 'containers/Group/AdminGroupListPage';
import GroupFormPage from 'containers/Group/GroupFormPage';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  return (
    <Switch>
      <SessionLayout path={ROUTES.session.login.path} component={LoginPage} />

      { /* Admin */ }
      { /* Admin - Analyze */ }
      <AdminLayout path={ROUTES.admin.analyze.overview.path} component={PlaceholderPage} />
      <AdminLayout path={ROUTES.admin.analyze.users.path} component={PlaceholderPage} />

      { /* Admin - Manage */ }
      { /* Admin - Manage - Groups */ }
      <AdminLayout exact path={ROUTES.admin.manage.groups.index.path} component={AdminGroupListPage} />
      <AdminLayout path={ROUTES.admin.manage.groups.new.path} component={GroupFormPage} />
      <AdminLayout path={ROUTES.admin.manage.groups.edit.path} component={GroupFormPage} />
      <AdminLayout path={ROUTES.admin.manage.groups.delete.path} component={PlaceholderPage} />

      { /* User */ }
      <UserLayout exact path={ROUTES.user.home.path} pageTitle={ROUTES.user.home.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.innovate.path} pageTitle={ROUTES.user.innovate.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.news.path} pageTitle={ROUTES.user.news.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.events.path} pageTitle={ROUTES.user.events.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.groups.path} pageTitle={ROUTES.user.groups.titleMessage} component={UserGroupListPage} />
      <UserLayout path={ROUTES.user.downloads.path} pageTitle={ROUTES.user.downloads.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.mentorship.path} pageTitle={ROUTES.user.mentorship.titleMessage} component={PlaceholderPage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
