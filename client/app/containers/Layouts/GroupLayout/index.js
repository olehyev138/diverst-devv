import React, { memo } from 'react';
import { Route } from 'react-router';

import GroupLinks from 'components/GroupLinks';
import ApplicationLayout from '../ApplicationLayout';


const GroupLayout = ({ component: Component, ...rest }) => (
  <div>
    <ApplicationLayout
      {...rest}
      position='static'
      component={matchProps => (
        <GroupLinks {...matchProps} />
      )}
    />
    <Component {...rest} />
  </div>
);

export default GroupLayout;
