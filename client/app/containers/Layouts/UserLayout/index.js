import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";
import classNames from "classnames";

import Container from "@material-ui/core/Container";
import UserLinks from 'components/UserLinks';
import { withStyles } from "@material-ui/core/styles";
import AuthenticatedLayout from "../AuthenticatedLayout";

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const UserLayout = ({component: Component, pageTitle: pageTitle, ...rest}) => {
  const { classes, ...other } = rest;

  return (
    <AuthenticatedLayout position='absolute' {...other} component={matchProps => (
      <React.Fragment>
        <div className={classes.toolbar} />
        <UserLinks pageTitle={pageTitle} {...matchProps} />

        <Container>
          <div className={classes.content}>
            <Component {...other} />
          </div>
        </Container>
      </React.Fragment>
    )}/>
  );
};

export default withStyles(styles)(UserLayout);
