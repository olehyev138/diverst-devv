import React, { memo } from 'react';
import { Route } from 'react-router';

import GroupLinks from 'components/GroupLinks';
import ApplicationLayout from "../ApplicationLayout";


const GroupLayout = ({component: Component, ...rest}) => {
  return (
    <ApplicationLayout {...rest} position='static' component={matchProps => (
      <GroupLinks {...matchProps}/>
    )}/>
  );
};

export default GroupLayout;
