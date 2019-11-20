import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  getSessionBegin, sessionsUnmount, updateSessionBegin
} from 'containers/Mentorship/Session/actions';

import { selectSession } from 'containers/Mentorship/Session/selectors';
import { selectMentoringInterests, selectMentoringTypes } from 'containers/Shared/App/selectors';

import saga from 'containers/Mentorship/saga';
import MentorshipSessionForm from 'components/Mentorship/SessionForm';

export function SessionProfilePage(props) {
  useInjectReducer({ key: 'mentorship', reducer });
  useInjectSaga({ key: 'mentorship', saga });

  const rs = new RouteService(useContext);

  return (
    <React.Fragment>
      <MentorshipSessionForm
        session={props.formSession}
        sessionAction={props.updateSessionBegin}
        interestOptions={props.interestOptions}
        typeOptions={props.typeOptions}
      />
    </React.Fragment>
  );
}

SessionProfilePage.propTypes = {
  updateSessionBegin: PropTypes.func,
  path: PropTypes.string,
  session: PropTypes.object,
  formSession: PropTypes.object,
  getSessionBegin: PropTypes.func,
  sessionUnmount: PropTypes.func,
  interestOptions: PropTypes.array,
  typeOptions: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  formSession: selectSession(),
  interestOptions: selectMentoringInterests(),
  typeOptions: selectMentoringTypes()
});

const mapDispatchToProps = {
  getSessionBegin,
  sessionsUnmount,
  updateSessionBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SessionProfilePage);
