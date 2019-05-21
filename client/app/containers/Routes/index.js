import React from 'react';
import { Router, Route, Switch } from 'react-router';
import { Redirect } from 'react-router-dom';

import AuthService from "utils/authService";
import { history } from "../../configureRedux";

//import { LandingPage, LoginPage, NotFoundPage, HomePage, AdminPage, CampaignsPage, NewsPage, EventsPage, GroupsPage } from './templates';

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

// TODO: how does this scale?
export default function Routes() {
  return (
    <Router history={history}>
      <Switch>
        <Login path='/login' component={LoginPage}/>
        {
          /*
            <AuthenticatedRoute exact path="/" component={HomePage}/>
            <AuthenticatedRoute path='/home' component={HomePage} />
            <AuthenticatedRoute path='/campaigns' component={CampaignsPage} />
            <AuthenticatedRoute path='/news' component={NewsPage} />
            <AuthenticatedRoute path='/events' component={EventsPage} />
            <AuthenticatedRoute path='/groups' component={GroupsPage} />
            <AuthenticatedRoute path='/admin/analytics' component={AdminPage} />
           */
        }
        <Route path='' component={NotFoundPage} />
      </Switch>
    </Router>
  );
}
