import React, { memo, useEffect } from 'react';
import { Redirect } from 'react-router-dom';
import { compose } from 'redux';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Backdrop, Card, Fade, CardContent, CircularProgress, Typography, Box } from '@material-ui/core';
import ConnectionFailedIcon from '@material-ui/icons/CloudOff';

import ApplicationHeader from 'components/Shared/ApplicationHeader';
import ApplicationFooter from 'components/Shared/ApplicationFooter';

import { loginSuccess, logoutSuccess, fetchUserDataBegin } from 'containers/Shared/App/actions';

import { createStructuredSelector } from 'reselect';
import {
  selectFetchUserDataError,
  selectIsFetchingUserData,
  selectToken,
  selectUser,
} from 'containers/Shared/App/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';
import AuthService from 'utils/authService';

import { Settings } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/App/messages';

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
  connectFailedCardContent: {
    textAlign: 'center',
    padding: 20,
    paddingBottom: 24,
  },
  connectFailedIcon: {
    fontSize: 64,
  },
});

const axios = require('axios');

const NotAuthenticated = () => <Redirect to={ROUTES.session.login.path()} />;

const AuthenticatedLayout = (props) => {
  const {
    classes, data, renderAppBar, drawerToggleCallback, drawerOpen,
    position, isAdmin, userData, isFetchingUserData, fetchUserDataError,
    ...rest
  } = props;

  const userJwt = AuthService.getJwt();
  const userDataLoaded = userData && userData.user_id; // Can't check just userData cause it might have enterprise from session

  useEffect(() => {
    if (!userJwt) return;

    if (!userDataLoaded) {
      rest.loginSuccess(userJwt);
      axios.defaults.headers.common['Diverst-UserToken'] = userJwt;
      rest.fetchUserDataBegin();
    }
  }, []);

  useEffect(() => {
    if (!userDataLoaded) return;

    // Set user time zone from their profile settings
    Settings.defaultZoneName = userData.time_zone;
  }, [userData]);

  /* Use AuthService to keep AuthenticatedLayout unconnected from store.
   *   - Probably better to keep layouts unconnected too
   *   - Causes problems when state updates, causing children to remount
   */

  if (userJwt) {
    if (userDataLoaded)
      return (
        <React.Fragment>
          { !!renderAppBar && (
            <React.Fragment>
              <ApplicationHeader
                drawerToggleCallback={drawerToggleCallback}
                drawerOpen={drawerOpen}
                position={position}
                isAdmin={isAdmin}
              />
            </React.Fragment>
          )}
          <Fade in appear>
            <Box height='100%' display='flex' flexDirection='column' overflow='hidden'>
              {props.children}
            </Box>
          </Fade>
          <ApplicationFooter />
        </React.Fragment>
      );

    return (
      <Backdrop open={!userData}>
        {!props.fetchUserDataError && (
          <CircularProgress
            color='secondary'
            size={60}
            thickness={1}
          />
        )}
        {props.fetchUserDataError && (
          <Fade in appear>
            <Card elevation={24}>
              <CardContent className={classes.connectFailedCardContent}>
                <ConnectionFailedIcon color='primary' className={classes.connectFailedIcon} />
                <br />
                <br />
                <Typography variant='h6' color='primary'>
                  <DiverstFormattedMessage {...messages.errors.fetchUserData} />
                </Typography>
              </CardContent>
            </Card>
          </Fade>
        )}
      </Backdrop>
    );
  }

  // Not Authenticated
  return <NotAuthenticated />;
};

const mapStateToProps = createStructuredSelector({
  token: selectToken(),
  userData: selectUser(),
  isFetchingUserData: selectIsFetchingUserData(),
  fetchUserDataError: selectFetchUserDataError(),
});

const mapDispatchToProps = {
  fetchUserDataBegin,
  loginSuccess,
  logoutSuccess,
};

AuthenticatedLayout.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.any,
  fetchUserDataBegin: PropTypes.func,
  isFetchingUserData: PropTypes.bool,
  fetchUserDataError: PropTypes.bool,
  loginSuccess: PropTypes.func,
  logoutSuccess: PropTypes.func,
  renderAppBar: PropTypes.bool,
  drawerOpen: PropTypes.bool,
  drawerToggleCallback: PropTypes.func,
  position: PropTypes.string,
  isAdmin: PropTypes.bool,
  token: PropTypes.string,
  userData: PropTypes.any,
  children: PropTypes.any,
};

AuthenticatedLayout.defaultProps = {
  renderAppBar: true
};

export const StyledAuthenticatedLayout = withStyles(styles)(AuthenticatedLayout);

export default compose(
  connect(mapStateToProps, mapDispatchToProps), // Only connect for dispatching actions
  memo,
  withStyles(styles),
)(AuthenticatedLayout);
