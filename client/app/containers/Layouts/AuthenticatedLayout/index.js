import React, { memo } from 'react';
import { Redirect } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import ApplicationHeader from 'components/Shared/ApplicationHeader';
import ApplicationLayout from 'containers/Layouts/ApplicationLayout';

import { ROUTES } from 'containers/Shared/Routes/constants';
import AuthService from 'utils/authService';
import { loginSuccess, logoutSuccess, setUserData } from 'containers/Shared/App/actions';

import { Settings } from 'luxon'; // Timezone and locale

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
});

const axios = require('axios');

const AuthenticatedLayout = ({
  renderAppBar, drawerToggleCallback, drawerOpen, position, isAdmin, component: Component, ...rest
}) => {
  const {
    classes, data, ...other
  } = rest;

  const NotAuthenticated = () => <Redirect to={ROUTES.session.login.path()} />;
  const NotAuthorized = () => <React.Fragment />; // TODO: Make a 'not authorized' page of some sort

  /* Use AuthService to keep AuthenticatedLayout unconnected from store.
   *   - Probably better to keep layouts unconnected too
   *   - Causes problems when state updates, causing children to remount
   */
  const userJwt = AuthService.getJwt();
  const userData = AuthService.getUserData();

  if (userJwt) {
    // Log the user out if they have a JWT but no data
    if (!userData) {
      AuthService.discardJwt();
      other.logoutSuccess();
      return <NotAuthenticated />;
    }

    // Authenticated
    if (!AuthService.isUserInStore()) {
      axios.defaults.headers.common['Diverst-UserToken'] = userJwt;
      other.loginSuccess(userJwt);
      other.setUserData(userData);
    }
    // Set user time zone from their profile settings
    Settings.defaultZoneName = userData.time_zone;
    // TODO: Set user locale
    // Settings.defaultLocale = 'en';

    // TODO: Handle if policy group isn't set. Perhaps clear token (sign out) if the policy group is not found
    if (AuthService.hasPermission(data))
      // Authorized - note: if no `permission` is defined on the route object it renders the
      // page as normal (for situations where the page doesn't have a permission associated)
      return (
        <ApplicationLayout
          {...other}
          component={matchProps => (
            <React.Fragment>
              { !!renderAppBar && (
                <React.Fragment>
                  <ApplicationHeader
                    drawerToggleCallback={drawerToggleCallback}
                    drawerOpen={drawerOpen}
                    position={position}
                    isAdmin={isAdmin}
                    {...matchProps}
                  />
                </React.Fragment>
              )}
              <Fade in appear>
                <Component {...matchProps} />
              </Fade>
            </React.Fragment>
          )}
        />
      );

    // Not Authorized
    return <NotAuthorized />;
  }

  // Not Authenticated
  return <NotAuthenticated />;
};

const mapDispatchToProps = {
  loginSuccess,
  logoutSuccess,
  setUserData,
};

AuthenticatedLayout.propTypes = {
  loginSuccess: PropTypes.func,
  logoutSuccess: PropTypes.func,
  setUserData: PropTypes.func,
  renderAppBar: PropTypes.bool,
  drawerOpen: PropTypes.bool,
  drawerToggleCallback: PropTypes.func,
  position: PropTypes.string,
  isAdmin: PropTypes.bool,
  component: PropTypes.elementType,
};

AuthenticatedLayout.defaultProps = {
  renderAppBar: true
};

export const StyledAuthenticatedLayout = withStyles(styles)(AuthenticatedLayout);

export default compose(
  connect(undefined, mapDispatchToProps), // Only connect for dispatching actions
  memo,
  withStyles(styles),
)(AuthenticatedLayout);
