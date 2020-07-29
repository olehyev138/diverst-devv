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
import dig from 'object-dig';

import { useInjectReducer } from 'utils/injectReducer';


import ForgotPasswordForm from 'components/Session/ForgotPasswordForm';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/User/PasswordResetPage/saga';
import reducer from 'containers/User/PasswordResetPage/reducer';
import { requestPasswordResetBegin } from 'containers/User/PasswordResetPage/actions';

export function ForgotPasswordPage(props) {
  useInjectReducer({ key: 'forgotPassword', reducer });
  useInjectSaga({ key: 'forgotPassword', saga });

  const [email, setEmail] = useState(dig(props.location, 'state', 'email') || '');

  return (
    <ForgotPasswordForm
      email={email}
      forgotPasswordBegin={props.requestPasswordResetBegin}
    />
  );
}

ForgotPasswordPage.propTypes = {
  location: PropTypes.object,
  requestPasswordResetBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  requestPasswordResetBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ForgotPasswordPage);
