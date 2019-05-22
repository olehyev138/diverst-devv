import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";

import ApplicationHeader from 'components/ApplicationHeader';

const ApplicationLayout = ({component: Component, ...rest}) => {
  return (
    AuthService.isAuthenticated() === true ?
      <Route {...rest} render={matchProps => (
        <ApplicationHeader position='static' {...matchProps}/>
      )} />
      : <div/>
  )
};

export default ApplicationLayout;
