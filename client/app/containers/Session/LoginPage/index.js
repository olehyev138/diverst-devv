/**
 *
 * LoginPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { push } from 'connected-react-router';
import { useLocation } from 'react-router-dom';

import { useInjectReducer } from 'utils/injectReducer';

import reducer from './reducer';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { loginBegin, ssoLoginBegin, ssoLinkBegin } from 'containers/Shared/App/actions';

import { selectIsLoggingIn, selectLoginSuccess } from './selectors';

import LoginForm from 'components/Session/LoginForm';
import EnterpriseForm from 'components/Session/EnterpriseForm';
import { Backdrop, CircularProgress } from '@material-ui/core';

export function LoginPage(props) {
  useInjectReducer({ key: 'loginPage', reducer });

  const location = useLocation();

  const [email, setEmail] = useState('');

  useEffect(() => {
    /* global URLSearchParams */
    const query = new URLSearchParams(location.search);

    // SSO
    const userToken = query.get('userToken');
    const errorMessage = query.get('errorMessage');

    if (errorMessage) {
      props.showSnackbar(errorMessage);
      props.refresh('login');
    }

    if (userToken)
      // Login after successful SSO login
      props.ssoLoginBegin({ userToken });
    else if (props.enterprise && props.enterprise.has_enabled_saml)
      // Redirect to configured SSO IDP
      props.ssoLinkBegin({ enterpriseId: props.enterprise.id });
  }, []);

  if (props.enterprise && props.enterprise.has_enabled_saml)
    return (
      <Backdrop open={!props.enterprise}>
        <CircularProgress
          color='secondary'
          size={60}
          thickness={1}
        />
      </Backdrop>
    );

  return (
    <LoginForm
      email={email}
      loginBegin={values => props.loginBegin(values)}
      isLoggingIn={props.isLoggingIn}
      loginSuccess={props.loginSuccess}
    />
  );
}

LoginPage.propTypes = {
  enterprise: PropTypes.object,
  location: PropTypes.shape({
    search: PropTypes.string
  }),
  showSnackbar: PropTypes.func,
  refresh: PropTypes.func,
  loginBegin: PropTypes.func,
  ssoLoginBegin: PropTypes.func,
  ssoLinkBegin: PropTypes.func,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isLoggingIn: selectIsLoggingIn(),
  loginSuccess: selectLoginSuccess(),
});

function mapDispatchToProps(dispatch) {
  return {
    showSnackbar: payload => dispatch(showSnackbar({ message: payload })),
    refresh: payload => dispatch(push(payload)),
    loginBegin: payload => dispatch(loginBegin(payload)),
    ssoLoginBegin: payload => dispatch(ssoLoginBegin(payload)),
    ssoLinkBegin: payload => dispatch(ssoLinkBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(LoginPage);
