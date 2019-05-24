import React, { memo } from 'react';
import { Route } from 'react-router';
import { compose } from "redux";

import AdminLinks from 'components/AdminLinks';
import ApplicationLayout from "../ApplicationLayout";
import { withStyles } from "@material-ui/core/styles";

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
});

const AdminLayout = ({component: Component, classes: classes, ...rest}) => {
  return (
    <ApplicationLayout {...rest} position='fixed' isAdmin component={matchProps => (
      <div>
        <AdminLinks {...matchProps} />
      </div>
    )}/>
  );
};

export default withStyles(styles)(AdminLayout);
