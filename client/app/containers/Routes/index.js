import React from 'react';
import { Router, Route, Switch } from 'react-router';
import { Redirect } from 'react-router-dom';

import AuthService from "utils/authService";
import { history } from "../../configureStore";

//import { LandingPage, LoginPage, NotFoundPage, HomePage, AdminPage, CampaignsPage, NewsPage, EventsPage, GroupsPage } from './templates';
import { LoginPage, NotFoundPage, HomePage } from './templates';

// Layouts
import ApplicationLayout from "../Layouts/ApplicationLayout";
import UserLayout from "../Layouts/UserLayout";
import GroupLayout from "../Layouts/GroupLayout";
import AdminLayout from "../Layouts/AdminLayout";


  /*
    <AuthenticatedRoute exact path="/" component={HomePage}/>
    <AuthenticatedRoute path='/home' component={HomePage} />
    <AuthenticatedRoute path='/campaigns' component={CampaignsPage} />
    <AuthenticatedRoute path='/news' component={NewsPage} />
    <AuthenticatedRoute path='/events' component={EventsPage} />
    <AuthenticatedRoute path='/groups' component={GroupsPage} />
    <AuthenticatedRoute path='/admin/analytics' component={AdminPage} />
   */

const AuthenticatedRoute = ({ component: ReactComponent, ...rest }) => (
  <Route {...rest} render={(props) =>
    (AuthService.isAuthenticated() === true ? <ReactComponent {...props} /> : <Redirect to='/login' />)}
  />
);

const Login = ({ component: ReactComponent, ...rest }) => (
  <Route {...rest} render={(props) => (
    AuthService.getJwt()
      ? <Redirect to='/home' /> : <ReactComponent {...props} />
  )}
  />
);

export default function Routes() {
  return (
    <Router history={history}>
      <Switch>
        <AdminLayout path='/admin'/>
        <GroupLayout path='/groups'/>
        <UserLayout path='/'/>
      </Switch>

      <Switch>
        <Login path='/login' component={LoginPage}/>
        <AuthenticatedRoute exact path="/" component={HomePage}/>
        <AuthenticatedRoute path='/home' component={HomePage} />
        <AuthenticatedRoute path='/admin/analytics' component={LoginPage} />
        <Route path='' component={NotFoundPage} />
      </Switch>
    </Router>
  );
}
