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

import reducer from './reducer';

import ForgotPasswordForm from 'components/Session/ForgotPasswordForm';

export function ForgotPasswordPage(props) {
  useInjectReducer({ key: 'forgotPasswordPage', reducer });

  const [email, setEmail] = useState(dig(props.location, 'state', 'email') || '');

  return (
    <ForgotPasswordForm
      email={email}
    />
  );
}

ForgotPasswordPage.propTypes = {
  location: PropTypes.object,
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
