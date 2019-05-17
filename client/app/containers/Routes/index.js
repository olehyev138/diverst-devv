import React from 'react';
import { Router, Route, Switch } from 'react-router';
import { Redirect } from 'react-router-dom';
import { LandingPage, LoginPage, NotFoundPage, HomePage, AdminPage, CampaignsPage, NewsPage, EventsPage, GroupsPage } from './templates';

import AuthService from "utils/authService";
import { history } from "../../configureRedux";

const AuthenticatedRoute = ({ component: ReactComponent, ...rest }) => (
  <Route {...rest} render={(props) => (
    AuthService.isAuthenticated() === true
      ? <ReactComponent {...props} />: <Redirect to='/login' />
  )
  }
  />
);

const Login = ({ component: ReactComponent, ...rest }) => (

  <Route {...rest} render={(props) => (
    AuthService.getJwt()
      ? <Redirect to='/users/home' /> : <ReactComponent {...props} />
  )
  }
  />
);


export default function Routes() {
  return (
    <Router history={history}>
      <Switch>
        <Route exact path="/" component={LandingPage}/>
        <Login path='/login' component={LoginPage}/>
        <AuthenticatedRoute path='/users/home' component={HomePage} />
        <AuthenticatedRoute path='/users/campaigns' component={CampaignsPage} />
        <AuthenticatedRoute path='/users/news' component={NewsPage} />
        <AuthenticatedRoute path='/users/events' component={EventsPage} />
        <AuthenticatedRoute path='/users/groups' component={GroupsPage} />
        <AuthenticatedRoute path='/admins/analytics' component={AdminPage} />
        <Route path="" component={NotFoundPage} />
      </Switch>
    </Router>
  );
}
