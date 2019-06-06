import React from 'react';
import { Switch } from 'react-router';

// Layouts
import UserLayout from '../Layouts/UserLayout';
import GroupLayout from '../Layouts/GroupLayout';
import AdminLayout from '../Layouts/AdminLayout';
import SessionLayout from '../Layouts/SessionLayout';
import ErrorLayout from '../Layouts/ErrorLayout';

// Pages
import { HomePage, LoginPage, NotFoundPage } from './templates';

// Paths
import {
  ADMIN_ANALYTICS_PATH, ADMIN_PATH, GROUP_PATH, HOME_PATH, LOGIN_PATH
} from './constants';

export default function Routes() {
  return (
    <Switch>
      <SessionLayout path={LOGIN_PATH} component={LoginPage} />

      <AdminLayout path={ADMIN_PATH} component={HomePage} />
      <AdminLayout path={ADMIN_ANALYTICS_PATH} component={HomePage} />

      <GroupLayout path={GROUP_PATH} />

      <UserLayout exact path={HOME_PATH} pageTitle='Home' component={HomePage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
