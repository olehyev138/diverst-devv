import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";
import classNames from "classnames";

import Container from "@material-ui/core/Container";
import UserLinks from 'components/UserLinks';
import { withStyles } from "@material-ui/core/styles";
import AuthenticatedLayout from "../AuthenticatedLayout";

const styles = theme => ({
  fullWidth: {
    width: '100%',
  },
  toolbar: theme.mixins.toolbar,
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
});

const UserLayout = ({component: Component, ...rest}) => {
  const { classes, ...other } = rest;

  return (
    <div className={classes.fullWidth}>
      <AuthenticatedLayout position='fixed' component={matchProps => (
        <div>
          <div className={classes.toolbar} />
          <UserLinks {...matchProps} />

          <Container>
            <div className={classes.content}>
              <Component {...other} />
            </div>
          </Container>
        </div>
      )}/>
    </div>
  );
};

export default withStyles(styles)(UserLayout);
