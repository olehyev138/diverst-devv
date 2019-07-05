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

import Groups from 'containers/Group/Groups';

// Paths
import { ROUTES } from 'containers/Shared/Routes/constants';

export default function Routes(props) {
  return (
    <Switch>
      <SessionLayout path={ROUTES.session.login.path} component={LoginPage} />

      <AdminLayout path={ROUTES.admin.analytics.overview.path} route={ROUTES.admin.analytics.overview} component={PlaceholderPage} />
      <AdminLayout path={ROUTES.admin.analytics.users.path} route={ROUTES.admin.analytics.users} component={PlaceholderPage} />

      { /* <GroupLayout path={ROUTES.group.home.path} /> */ }

      <UserLayout exact path={ROUTES.user.home.path} route={ROUTES.user.home} pageTitle={ROUTES.user.home.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.innovate.path} route={ROUTES.user.innovate} pageTitle={ROUTES.user.innovate.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.news.path} route={ROUTES.user.news} pageTitle={ROUTES.user.news.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.events.path} route={ROUTES.user.events} pageTitle={ROUTES.user.events.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.groups.path} route={ROUTES.user.groups} pageTitle={ROUTES.user.groups.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.downloads.path} route={ROUTES.user.downloads} pageTitle={ROUTES.user.downloads.titleMessage} component={PlaceholderPage} />
      <UserLayout path={ROUTES.user.mentorship.path} route={ROUTES.user.mentorship} pageTitle={ROUTES.user.mentorship.titleMessage} component={PlaceholderPage} />

      <UserLayout path={ROUTES.groups.home.path} route={ROUTES.groups.home} pageTitle={ROUTES.groups.home.titleMessage} component={Groups} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
