import React, { memo } from 'react';
import { Route } from 'react-router';
import { compose } from "redux";

import Container from "@material-ui/core/Container";
import AdminLinks from 'components/AdminLinks';
import { withStyles } from "@material-ui/core/styles";
import AuthenticatedLayout from "../AuthenticatedLayout";

const styles = theme => ({
  flex: {
    display: 'flex',
  },
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const AdminLayout = ({component: Component, ...rest}) => {
  const { classes, ...other } = rest;

  return (
    <AuthenticatedLayout position='fixed' isAdmin component={matchProps => (
      <div className={classes.flex}>
        <AdminLinks {...matchProps} />

        <Container maxWidth='xl'>
          <div className={classes.content}>
            <div className={classes.toolbar} />
            <Component {...other} />
          </div>
        </Container>
      </div>
    )}/>
  );
};

export default withStyles(styles)(AdminLayout);
