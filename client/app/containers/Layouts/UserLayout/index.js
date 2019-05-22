import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";

import ApplicationLayout from "../ApplicationLayout";
import UserLinks from 'components/UserLinks';

const UserLayout = ({component: Component, ...rest}) => {
  return (
    <ApplicationLayout {...rest} position='static' component={matchProps => (
      <UserLinks {...matchProps}/>
    )}/>
  );
};

export default UserLayout;
