import React, { memo, useEffect } from 'react';
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
  selectResponse,
  selectIsLoading,
  selectIsCommitting,
  selectFormErrors,
} from './selectors';

import {
  getQuestionnaireByTokenBegin,
  submitResponseBegin,
  pollResponseUnmount,
} from './actions';

import { injectIntl } from 'react-intl';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { ROUTES } from 'containers/Shared/Routes/constants';
import PollResponseForm from 'components/Poll/PollResponseForm';

export function PollResponsePage(props) {
  useInjectReducer({ key: 'pollResponse', reducer });
  useInjectSaga({ key: 'pollResponse', saga });

  const { token } = useParams();

  useEffect(() => {
    if (token)
      props.getQuestionnaireByTokenBegin({
        token
      });
    else {
      props.showSnackbar({
        message: 'You need nave an invitation answer this poll',
        options: { variant: 'warning' }
      });
      props.redirectAction(ROUTES.user.home.path());
    }
    return () => props.pollResponseUnmount();
  }, []);

  return (
    <PollResponseForm
      response={props.response}
      isLoading={props.isLoading}
      isCommitting={props.isCommitting}
      token={props.token}
      errors={props.formErrors}

      submitAction={props.submitResponseBegin}
    />
  );
}

PollResponsePage.propTypes = {
  getQuestionnaireByTokenBegin: PropTypes.func,
  submitResponseBegin: PropTypes.func,
  pollResponseUnmount: PropTypes.func,
  showSnackbar: PropTypes.func,
  redirectAction: PropTypes.func,

  isCommitting: PropTypes.bool,
  token: PropTypes.string,
  response: PropTypes.object,
  isLoading: PropTypes.bool,
  formErrors: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  token: selectToken(),
  response: selectResponse(),
  isLoading: selectIsLoading(),
  formErrors: selectFormErrors(),
});

const mapDispatchToProps = {
  getQuestionnaireByTokenBegin,
  submitResponseBegin,
  pollResponseUnmount,
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
)(PollResponsePage);
