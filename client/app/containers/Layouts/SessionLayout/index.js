import React, { memo } from 'react';
import { Route } from 'react-router';
import { Redirect } from 'react-router-dom';
import AuthService from "utils/authService";

import Container from "@material-ui/core/Container";
import ApplicationLayout from "../ApplicationLayout";
import { withStyles } from "@material-ui/core/styles";

const styles = theme => ({
  container: {
    height: '100%',
  },
  content: {
    height: '100%',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

const SessionLayout = ({component: Component, ...rest}) => {
  const { classes, ...other } = rest;

  return (
    AuthService.isAuthenticated() === false ?
      <ApplicationLayout {...other} component={matchProps => (
        <Container maxWidth="sm" className={classes.container}>
          <div className={classes.content}>
            <Component {...other} />
          </div>
        </Container>
      )}/>
    :
      <Redirect to='/home' />
  );
};

export default withStyles(styles)(SessionLayout);
