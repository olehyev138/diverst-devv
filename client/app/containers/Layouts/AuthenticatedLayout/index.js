import React, { memo } from 'react';
import { Route } from 'react-router';
import { Redirect } from 'react-router-dom';
import AuthService from 'utils/authService';

import { withStyles } from '@material-ui/core/styles';

import ApplicationLayout from '../ApplicationLayout';
import ApplicationHeader from 'components/ApplicationHeader';

const styles = theme => ({});

const AuthenticatedLayout = ({
  renderAppBar, position, isAdmin, component: Component, ...rest
}) => {
  const { classes } = rest;

  return (
    AuthService.isAuthenticated() === true
      ? (
        <ApplicationLayout
          component={matchProps => (
            <div>
              {
                renderAppBar === false
                  ? <React.Fragment />
                  : <ApplicationHeader position={position} isAdmin={isAdmin} {...matchProps} />
              }
              <Component {...matchProps} />
            </div>
          )}
        />
      )
      : <Redirect to='/login' />
  );
};

export default withStyles(styles)(AuthenticatedLayout);
