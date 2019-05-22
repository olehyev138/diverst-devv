import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";

import UserLinks from 'components/UserLinks';

const UserLayout = ({component: Component, ...rest}) => {
  return (
    AuthService.isAuthenticated() === true ?
      <Route {...rest} render={matchProps => (
        <UserLinks {...matchProps}/>
      )} />
      : <div/>
  )
};

export default UserLayout;
