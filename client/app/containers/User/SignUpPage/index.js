import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from './reducer';
import saga from './saga';

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
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import SignUpForm from 'components/User/SignUpForm';

const redirectAction = url => push(url);

export function SignUpPage(props) {
  useInjectReducer({ key: 'signUp', reducer });
  useInjectSaga({ key: 'signUp', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    const token = rs.params('token');

    if (token)
      props.getUserByTokenBegin({
        token
      });
    else {
      props.showSnackbar({
        message: 'You need nave an invitation to sign up',
        options: { variant: 'warning' }
      });
      props.redirectAction(ROUTES.session.login.path());
    }
    return () => props.signUpUnmount();
  }, []);

  return (
    <SignUpForm
      user={props.user}
      isLoading={props.isLoading}
      isCommitting={props.isCommitting}
      token={props.token}
      errors={props.formErrors}

      submitAction={props.submitPasswordBegin}
      buttonText='Sign Up'
    />
  );
}

SignUpPage.propTypes = {
  getUserByTokenBegin: PropTypes.func,
  submitPasswordBegin: PropTypes.func,
  signUpUnmount: PropTypes.func,
  showSnackbar: PropTypes.func,
  redirectAction: PropTypes.func,

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
  showSnackbar,
  redirectAction,
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
