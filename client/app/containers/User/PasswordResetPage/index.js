import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from './reducer';
import saga from './saga';
import { redirectAction } from 'utils/reduxPushHelper';

import {
  selectToken,
  selectUser,
  selectIsLoading,
  selectIsCommitting,
} from './selectors';

import {
  getUserByTokenBegin,
  submitPasswordBegin,
  signUpUnmount,
} from './actions';

import { injectIntl, intlShape } from 'react-intl';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import PasswordResetForm from 'components/User/PasswordResetForm';

export function PasswordResetPage(props) {
  useInjectReducer({ key: 'forgotPassword', reducer });
  useInjectSaga({ key: 'forgotPassword', saga });

  const { token } = useParams();

  useEffect(() => {
    if (token)
      props.getUserByTokenBegin({
        token
      });
    else {
      props.showSnackbar({
        message: 'diverst.containers.App.texts.reset.token',
        options: { variant: 'warning' }
      });
      props.redirectAction(ROUTES.session.login.path());
    }
    return () => props.signUpUnmount();
  }, []);

  return (
    <PasswordResetForm
      user={props.user}
      isLoading={props.isLoading}
      isCommitting={props.isCommitting}
      token={props.token}
      errors={props.formErrors}

      submitAction={props.submitPasswordBegin}
    />
  );
}

PasswordResetPage.propTypes = {
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
)(PasswordResetPage);
