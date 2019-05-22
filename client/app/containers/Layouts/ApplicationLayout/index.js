import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";

import ApplicationHeader from 'components/ApplicationHeader';

const ApplicationLayout = ({position: position, component: Component, ...rest}) => {
  return (
    AuthService.isAuthenticated() === true ?
      <Route {...rest} render={matchProps => (
        <div>
          <ApplicationHeader position={position} {...matchProps}/>
          <Component {...matchProps} />
        </div>
      )} />
      : <div/>
  )
};

export default ApplicationLayout;
