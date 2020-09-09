/**
 *
 * SSOLandingPage
 *
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { push } from 'connected-react-router';
import { Redirect, useLocation } from 'react-router-dom';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { ssoLinkBegin, ssoLoginBegin } from 'containers/Shared/App/actions';

import { Backdrop, CircularProgress } from '@material-ui/core';

import { ROUTES } from 'containers/Shared/Routes/constants';

import SSOLanding from 'components/Session/SSOLanding';

export function SSOLandingPage(props) {
  const { enterprise, ssoLinkBegin, ssoLoginBegin, showSnackbar, refresh, ...rest } = props;

  const location = useLocation();

  const handleEnter = () => ssoLinkBegin({ enterpriseId: enterprise.id }); // Redirect to configured SSO IDP

  useEffect(() => {
    /* global URLSearchParams */
    const query = new URLSearchParams(location.search);

    // SSO
    const userToken = query.get('userToken');
    const errorMessage = query.get('errorMessage');

    if (errorMessage) {
      showSnackbar(errorMessage);
      refresh();
    }

    if (userToken) // Login after successful SSO login
      ssoLoginBegin({ userToken });
  }, []);

  if (!enterprise || !enterprise.has_enabled_saml)
    return <Redirect to={ROUTES.session.login.path()} />;

  if (enterprise)
    return (
      <SSOLanding
        handleEnter={handleEnter}
      />
    );

  return (
    <Backdrop open>
      <CircularProgress
        color='secondary'
        size={60}
        thickness={1}
      />
    </Backdrop>
  );
}

SSOLandingPage.propTypes = {
  enterprise: PropTypes.object.isRequired,
  showSnackbar: PropTypes.func.isRequired,
  refresh: PropTypes.func.isRequired,
  ssoLinkBegin: PropTypes.func.isRequired,
  ssoLoginBegin: PropTypes.func.isRequired,
};

function mapDispatchToProps(dispatch) {
  return {
    showSnackbar: payload => dispatch(showSnackbar({ message: payload })),
    refresh: () => dispatch(push(ROUTES.session.ssoLanding.path())),
    ssoLinkBegin: payload => dispatch(ssoLinkBegin(payload)),
    ssoLoginBegin: payload => dispatch(ssoLoginBegin(payload)),
  };
}

const withConnect = connect(
  undefined,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SSOLandingPage);
