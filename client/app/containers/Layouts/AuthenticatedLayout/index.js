import React, { memo } from 'react';
import { Route } from 'react-router';
import { Redirect } from 'react-router-dom';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import AuthService from 'utils/authService';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';

import ApplicationHeader from 'components/Shared/ApplicationHeader';
import ApplicationLayout from 'containers/Layouts/ApplicationLayout';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectEnterprise, selectUserPolicyGroup } from 'containers/Shared/App/selectors';

const styles = theme => ({});

const AuthenticatedLayout = ({
  renderAppBar, drawerToggleCallback, drawerOpen, position, isAdmin, component: Component, ...rest
}) => {
  const {
    classes, route, policyGroup, ...other
  } = rest;

  if (AuthService.isAuthenticated() === true) {
    // Authenticated
    // TODO: Handle if policy group isn't set. Perhaps clear token (sign out) if the policy group is not found
    if (Object.prototype.hasOwnProperty.call(route, 'permission') === false || policyGroup[route.permission] === true)
      // Authorized - note: if no `permission` is defined on the route object it renders the
      // page as normal (for situations where the page doesn't have a permission associated)
      return (
        <ApplicationLayout
          {...other}
          component={matchProps => (
            <div>
              {
                renderAppBar === false
                  ? <React.Fragment />
                  : (
                    <ApplicationHeader
                      drawerToggleCallback={drawerToggleCallback}
                      drawerOpen={drawerOpen}
                      position={position}
                      isAdmin={isAdmin}
                      {...matchProps}
                    />
                  )
              }
              <Component {...matchProps} />
            </div>
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
    <Redirect to={ROUTES.session.login.path} />
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

const mapStateToProps = createStructuredSelector({
  policyGroup: selectUserPolicyGroup(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  withConnect,
  withStyles(styles),
)(AuthenticatedLayout);
