/**
 *
 * LoginPage
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { Redirect, useRouteMatch, useLocation } from 'react-router-dom';

import { useInjectReducer } from 'utils/injectReducer';

import reducer from './reducer';

import { loginBegin } from 'containers/Shared/App/actions';

import { selectIsLoggingIn, selectLoginSuccess } from './selectors';

import LoginForm from 'components/Session/LoginForm';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function LoginPage(props) {
  useInjectReducer({ key: 'loginPage', reducer });

  const location = useLocation();

  const ssoBypass = !!useRouteMatch(ROUTES.session.ssoBypass.path());

  const [email, setEmail] = useState('');

  if (props.enterprise && props.enterprise.has_enabled_saml && !ssoBypass)
    return (
      <Redirect
        to={{
          pathname: ROUTES.session.ssoLanding.path(),
          search: location.search, // Necessary to pass query params from an SSO provider that redirects to just /login
        }}
      />
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
  enterprise: PropTypes.object.isRequired,
  loginBegin: PropTypes.func.isRequired,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isLoggingIn: selectIsLoggingIn(),
  loginSuccess: selectLoginSuccess(),
});

const mapDispatchToProps = {
  loginBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(LoginPage);
