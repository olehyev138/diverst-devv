import React from 'react';
import { Router, Route, Switch } from 'react-router';
import { Redirect } from 'react-router-dom';

import AuthService from "utils/authService";

import CssBaseline from "@material-ui/core/CssBaseline";
import { LoginPage, NotFoundPage, HomePage } from './templates';

// Layouts
import ApplicationLayout from "../Layouts/ApplicationLayout";
import UserLayout from "../Layouts/UserLayout";
import GroupLayout from "../Layouts/GroupLayout";
import AdminLayout from "../Layouts/AdminLayout";
import SessionLayout from "../Layouts/SessionLayout";
import ErrorLayout from "../Layouts/ErrorLayout";
import Logo from "components/Logo";

export default function Routes() {
  return (
    <Switch>
      <SessionLayout path='/login' component={LoginPage} />

      <AdminLayout path='/admin' component={HomePage} />
      <AdminLayout path='/admin/analytics' component={HomePage} />

      <GroupLayout path='/groups' />

      <UserLayout exact path='/' pageTitle='Home' component={HomePage} />

      <ErrorLayout path='' component={NotFoundPage} />
    </Switch>
  );
}
