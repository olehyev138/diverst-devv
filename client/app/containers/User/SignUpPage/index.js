import React, { memo, useEffect, useState } from 'react';
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
  selectFormErrors,
  selectGroups,
  selectGroupsTotal,
  selectGroupsIsLoading,
} from './selectors';

import {
  getUserByTokenBegin,
  getOnboardingGroupsBegin,
  submitPasswordBegin,
  signUpUnmount,
} from './actions';

import { injectIntl } from 'react-intl';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { ROUTES } from 'containers/Shared/Routes/constants';
import SignUpForm from 'components/User/SignUpForm';
import { selectEnterprise } from 'containers/Shared/App/selectors';
import messages from '../messages';

export function SignUpPage(props) {
  useInjectReducer({ key: 'signUp', reducer });
  useInjectSaga({ key: 'signUp', saga });

  const { token } = useParams();

  const [handleGetOnboardingGroupsBegin, setHandleGetOnboardingGroupsBegin] = useState(null);

  useEffect(() => {
    if (token) {
      props.getUserByTokenBegin({ token });
      setHandleGetOnboardingGroupsBegin(() => params => props.getOnboardingGroupsBegin({ ...params, token }));
    } else {
      props.showSnackbar({
        message: messages.token,
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
      isGroupsLoading={props.isGroupsLoading}
      isCommitting={props.isCommitting}
      token={props.token}
      errors={props.formErrors}
      enterprise={props.enterprise}
      groups={props.groups}
      groupsTotal={props.groupsTotal}
      getOnboardingGroupsBegin={handleGetOnboardingGroupsBegin}
      getOnboardingGroupsSuccess={props.getOnboardingGroupsSuccess}

      submitAction={props.submitPasswordBegin}
    />
  );
}

SignUpPage.propTypes = {
  getUserByTokenBegin: PropTypes.func,
  getOnboardingGroupsBegin: PropTypes.func,
  getOnboardingGroupsSuccess: PropTypes.func,
  submitPasswordBegin: PropTypes.func,
  signUpUnmount: PropTypes.func,
  showSnackbar: PropTypes.func,
  redirectAction: PropTypes.func,

  isCommitting: PropTypes.bool,
  token: PropTypes.string,
  user: PropTypes.object,
  groups: PropTypes.arrayOf(PropTypes.object),
  groupsTotal: PropTypes.number,
  enterprise: PropTypes.object,
  isLoading: PropTypes.bool,
  isGroupsLoading: PropTypes.bool,
  formErrors: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  token: selectToken(),
  user: selectUser(),
  isLoading: selectIsLoading(),
  formErrors: selectFormErrors(),
  groups: selectGroups(),
  groupsTotal: selectGroupsTotal(),
  isGroupsLoading: selectGroupsIsLoading(),
  enterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  getUserByTokenBegin,
  getOnboardingGroupsBegin,
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
