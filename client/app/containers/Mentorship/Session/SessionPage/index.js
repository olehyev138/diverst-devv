import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Mentorship/Session/reducer';
import saga from 'containers/Mentorship/Session/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectUser } from 'containers/Mentorship/selectors';
import { selectUser as selectGlobalUser } from 'containers/Shared/App/selectors';
import {
  selectSession,
  selectPaginatedUsers,
  selectIsFetchingSession,
  selectIsFetchingSessions,
  selectIsCommitting, selectHasChanged,
} from 'containers/Mentorship/Session/selectors';

import {
  getSessionBegin,
  getParticipatingUsersBegin,
  deleteSessionBegin,
  acceptInvitationBegin,
  declineInvitationBegin,
  sessionsUnmount,
  sessionUsersUnmount,
} from 'containers/Mentorship/Session/actions';

import Session from 'components/Mentorship/Session';

export function SessionPage(props) {
  useInjectReducer({ key: 'sessions', reducer });
  useInjectSaga({ key: 'sessions', saga });

  const rs = new RouteService(useContext);
  const links = {
    sessionEdit: id => ROUTES.user.mentorship.sessions.edit.path(id),
  };

  useEffect(() => {
    const [sessionId] = rs.params('session_id');
    // get session specified in path
    props.getSessionBegin({ id: sessionId });
    props.getParticipatingUsersBegin({ sessionId });

    return () => props.sessionsUnmount();
  }, []);

  useEffect(() => {
    const [sessionId] = rs.params('session_id');

    if (props.hasChanged) {
      props.getSessionBegin({ id: sessionId });
      props.getParticipatingUsersBegin({ sessionId });
    }

    return () => props.sessionsUnmount();
  }, [props.hasChanged]);

  return (
    <Session
      deleteSession={props.deleteSessionBegin}
      acceptInvite={props.acceptInvitationBegin}
      declineInvite={props.declineInvitationBegin}

      links={links}

      user={props.user}
      loggedUser={props.loggedUser}
      session={props.session}

      users={props.users}

      isCommitting={props.isCommitting}
      isFetchingSessions={props.isFetchingSessions}
      isFetchingSession={props.isFetchingSession}
    />
  );
}

SessionPage.propTypes = {
  getSessionBegin: PropTypes.func,
  getParticipatingUsersBegin: PropTypes.func,
  deleteSessionBegin: PropTypes.func,
  acceptInvitationBegin: PropTypes.func,
  declineInvitationBegin: PropTypes.func,
  sessionsUnmount: PropTypes.func,
  sessionUsersUnmount: PropTypes.func,

  user: PropTypes.object,
  loggedUser: PropTypes.object,
  session: PropTypes.object,

  users: PropTypes.array,

  isFetchingSession: PropTypes.bool,
  isFetchingSessions: PropTypes.bool,
  isCommitting: PropTypes.bool,
  hasChanged: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  user: selectUser(),
  session: selectSession(),
  users: selectPaginatedUsers(),
  loggedUser: selectGlobalUser(),

  isFetchingSession: selectIsFetchingSession(),
  isFetchingSessions: selectIsFetchingSessions(),
  isCommitting: selectIsCommitting(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getSessionBegin,
  getParticipatingUsersBegin,
  acceptInvitationBegin,
  declineInvitationBegin,
  deleteSessionBegin,
  sessionsUnmount,
  sessionUsersUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SessionPage);
