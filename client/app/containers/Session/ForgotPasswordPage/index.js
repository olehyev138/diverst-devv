/**
 *
 * ForgotPasswordPage
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { useInjectReducer } from 'utils/injectReducer';

import reducer from './reducer';

import { loginBegin, ssoLoginBegin, ssoLinkBegin } from 'containers/Shared/App/actions';

import { selectIsLoggingIn, selectLoginSuccess } from './selectors';

import ForgotPasswordForm from 'components/Session/ForgotPasswordForm';

export function ForgotPasswordPage(props) {
  useInjectReducer({ key: 'forgotPasswordPage', reducer });

  const [email, setEmail] = useState('');

  return (
    <ForgotPasswordForm
      email={email}
    />
  );
}

ForgotPasswordPage.propTypes = {
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ForgotPasswordPage);
