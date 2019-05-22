import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";

import GroupLinks from 'components/GroupLinks';

const GroupLayout = ({component: Component, ...rest}) => {
  return (
    AuthService.isAuthenticated() === true ?
      <Route {...rest} render={matchProps => (
        <GroupLinks {...matchProps}/>
      )} />
      : <div/>
  )
};

export default GroupLayout;
