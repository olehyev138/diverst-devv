import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/Session/reducer';

import messages from 'containers/Mentorship/Session/messages';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getSessionBegin, sessionsUnmount, updateSessionBegin, createSessionBegin
} from 'containers/Mentorship/Session/actions';

import { selectFormSession, selectIsFetchingSession } from 'containers/Mentorship/Session/selectors';
import { selectMentoringInterests, selectCustomText } from 'containers/Shared/App/selectors';

import saga from 'containers/Mentorship/Session/saga';
import MentorshipSessionForm from 'components/Mentorship/SessionForm';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SessionProfilePage(props) {
  useInjectReducer({ key: 'sessions', reducer });
  useInjectSaga({ key: 'sessions', saga });

  const { session_id: sessionId } = useParams();
  const { type } = props;

  useEffect(() => {
    if (type === 'edit')
      props.getSessionBegin({ id: sessionId });

    return () => props.sessionsUnmount();
  }, []);

  return (
    <React.Fragment>
      <MentorshipSessionForm
        session={props.formSession}
        sessionAction={type === 'edit' ? props.updateSessionBegin : props.createSessionBegin}
        interestOptions={props.interestOptions}
        user={props.formUser}
        isCommiting={props.isCommitting}
        buttonText={type === 'edit'
          ? props.intl.formatMessage(messages.form.update, props.customTexts)
          : props.intl.formatMessage(messages.form.create, props.customTexts)}
        customTexts={props.customTexts}
      />
    </React.Fragment>
  );
}

SessionProfilePage.propTypes = {
  intl: intlShape.isRequired,
  formUser: PropTypes.object,
  type: PropTypes.string.isRequired,
  updateSessionBegin: PropTypes.func,
  createSessionBegin: PropTypes.func,
  path: PropTypes.string,
  session: PropTypes.object,
  isCommitting: PropTypes.bool,
  formSession: PropTypes.object,
  getSessionBegin: PropTypes.func,
  sessionsUnmount: PropTypes.func,
  interestOptions: PropTypes.array,
  typeOptions: PropTypes.array,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  formSession: selectFormSession(),
  isFormLoading: selectIsFetchingSession(),
  interestOptions: selectMentoringInterests(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  getSessionBegin,
  sessionsUnmount,
  updateSessionBegin,
  createSessionBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  injectIntl,
  memo,
)(Conditional(
  SessionProfilePage,
  ['type', 'formSession.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.user.mentorship.show.path(props?.sessionUser?.user_id),
  permissionMessages.mentorship.session.editPage,
  false,
  a => a[0] !== 'edit' || a.slice(1, 3).some(b => b)
));
