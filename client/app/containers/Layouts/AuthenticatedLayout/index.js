import React, { memo } from 'react';
import { Redirect } from 'react-router-dom';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import ApplicationHeader from 'components/Shared/ApplicationHeader';
import ApplicationLayout from 'containers/Layouts/ApplicationLayout';

import { ROUTES } from 'containers/Shared/Routes/constants';
import AuthService from 'utils/authService';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
});

const AuthenticatedLayout = ({
  renderAppBar, drawerToggleCallback, drawerOpen, position, isAdmin, component: Component, ...rest
}) => {
  const {
    classes, data, ...other
  } = rest;

  /* Use AuthService to keep AuthenticatedLayout unconnected from store.
   *   - Probably better to keep layouts unconnected too
   *   - Causes problems when state updates, causing children to remount
   */
  if (AuthService.isAuthenticated()) {
    // Authenticated
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
              <Component {...matchProps} />
            </React.Fragment>
          )}
        />
      );

    // Not Authorized - TODO: Make a "not authorized" page of some sort
    return (
      <React.Fragment />
    );
  }

  // Not Authenticated

  return (
    <Redirect to={ROUTES.session.login.path()} />
  );
};

AuthenticatedLayout.propTypes = {
  renderAppBar: PropTypes.bool,
  drawerOpen: PropTypes.bool,
  drawerToggleCallback: PropTypes.func,
  position: PropTypes.string,
  isAdmin: PropTypes.bool,
  component: PropTypes.elementType,
  policy_group: PropTypes.object,
};

AuthenticatedLayout.defaultProps = {
  renderAppBar: true
};

export const StyledAuthenticatedLayout = withStyles(styles)(AuthenticatedLayout);

export default compose(
  memo,
  withStyles(styles),
)(AuthenticatedLayout);
