import React, { memo } from 'react';
import { Route } from 'react-router';
import { Redirect } from 'react-router-dom';
import AuthService from 'utils/authService';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import ApplicationHeader from 'components/ApplicationHeader';
import ApplicationLayout from 'containers/Layouts/ApplicationLayout';

import { LOGIN_PATH } from 'containers/Routes/constants';

const styles = theme => ({});

const AuthenticatedLayout = ({
  renderAppBar, drawerToggleCallback, drawerOpen, position, isAdmin, component: Component, ...rest
}) => {
  const { classes, ...other } = rest;

  return (
    AuthService.isAuthenticated() === true
      ? (
        <ApplicationLayout
          {...other}
          component={matchProps => (
            <div>
              {
                renderAppBar === false
                  ? <React.Fragment />
                  : <ApplicationHeader drawerToggleCallback={drawerToggleCallback} drawerOpen={drawerOpen} position={position} isAdmin={isAdmin} {...matchProps} />
              }
              <Component {...matchProps} />
            </div>
          )}
        />
      )
      : <Redirect to={LOGIN_PATH} />
  );
};

AuthenticatedLayout.propTypes = {
  renderAppBar: PropTypes.bool,
  drawerOpen: PropTypes.bool,
  drawerToggleCallback: PropTypes.func,
  position: PropTypes.string,
  isAdmin: PropTypes.bool,
  component: PropTypes.elementType,
};

export default withStyles(styles)(AuthenticatedLayout);
