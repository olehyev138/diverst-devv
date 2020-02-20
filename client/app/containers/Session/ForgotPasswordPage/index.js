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
import { push } from 'connected-react-router';

import { useInjectReducer } from 'utils/injectReducer';

import reducer from './reducer';

import { CircularProgress, Backdrop } from '@material-ui/core';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { loginBegin, findEnterpriseBegin, ssoLoginBegin, ssoLinkBegin } from 'containers/Shared/App/actions';

import { selectEnterprise } from 'containers/Shared/App/selectors';
import { selectIsLoggingIn, selectLoginSuccess } from './selectors';

import ForgotPasswordForm from 'components/Session/ForgotPasswordForm';

export function ForgotPasswordPage(props) {
  useInjectReducer({ key: 'forgotPasswordPage', reducer });

  const [email, setEmail] = useState('');

  return (
    <React.Fragment>
      <ForgotPasswordForm
        email={email}
      />
    </React.Fragment>
  );
}

ForgotPasswordPage.propTypes = {
  enterprise: PropTypes.object,
  location: PropTypes.shape({
    search: PropTypes.string
  }),
  showSnackbar: PropTypes.func,
  refresh: PropTypes.func,
  loginBegin: PropTypes.func,
  ssoLoginBegin: PropTypes.func,
  ssoLinkBegin: PropTypes.func,
  findEnterpriseBegin: PropTypes.func,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
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
    findEnterpriseBegin: payload => dispatch(findEnterpriseBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ForgotPasswordPage);
