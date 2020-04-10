import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import {
  selectToken,
  selectUser,
  selectIsLoading,
  selectIsCommitting,
  selectFormErrors,
} from './selectors';

import {
  getUserByTokenBegin,
  submitPasswordBegin,
  signUpUnmount,
} from './actions';

import RouteService from 'utils/routeHelpers';

import { injectIntl, intlShape } from 'react-intl';

export function SignUpPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  useEffect(() => () => props.signUpUnmount(), []);

  const rs = new RouteService(useContext);

  return (
    <React.Fragment />
  );
}

SignUpPage.propTypes = {
  getUserByTokenBegin: PropTypes.func,
  submitPasswordBegin: PropTypes.func,
  signUpUnmount: PropTypes.func,

  isCommitting: PropTypes.bool,
  token: PropTypes.string,
  user: PropTypes.object,
  isLoading: PropTypes.bool,
  formErrors: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  token: selectToken(),
  user: selectUser(),
  isLoading: selectIsLoading(),
  formErrors: selectFormErrors(),
});

const mapDispatchToProps = {
  getUserByTokenBegin,
  submitPasswordBegin,
  signUpUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(SignUpPage);
