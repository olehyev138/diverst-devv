import React, { memo } from 'react';
import { Route } from 'react-router';

import AdminLinks from 'components/AdminLinks';
import ApplicationLayout from "../ApplicationLayout";

const AdminLayout = ({component: Component, ...rest}) => {
  return (
    <ApplicationLayout {...rest} position='fixed' component={matchProps => (
        <AdminLinks {...matchProps} />
    )}/>
  );
};

export default AdminLayout;
