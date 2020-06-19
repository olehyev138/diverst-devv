import React, { memo, useEffect, useState } from 'react';
import dig from 'object-dig';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Mentorship/Session/reducer';
import saga from 'containers/Mentorship/Session/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectUser as selectUserSession } from 'containers/Shared/App/selectors';
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
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'asc'
});

export function SessionPage(props) {
  useInjectReducer({ key: 'sessions', reducer });
  useInjectSaga({ key: 'sessions', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc', orderBy: 'id' });

  const { session_id: sessionId } = useParams();
  const links = {
    sessionEdit: id => ROUTES.user.mentorship.sessions.edit.path(id),
  };

  useEffect(() => {
    // get session specified in path
    props.getSessionBegin({ id: sessionId });
    props.getParticipatingUsersBegin({ ...defaultParams, sessionId });

    return () => props.sessionsUnmount();
  }, []);

  useEffect(() => {
    if (props.hasChanged) {
      props.getSessionBegin({ id: sessionId });
      props.getParticipatingUsersBegin({ ...params, sessionId });
    }

    return () => props.sessionsUnmount();
  }, [props.hasChanged]);

  function getParticipants(newParams = params) {
    if (dig(props, 'session', 'id')) {
      const sessionId = props.session.id;
      props.getParticipatingUsersBegin({ ...newParams, sessionId });
    }
  }

  const handleParticipantPagination = (payload) => {
    const oldPageNum = params.page;
    const oldRows = params.count;
    let newPageNum = payload.page;
    const newRows = payload.count;

    if (oldRows !== newRows) {
      const index = oldPageNum * oldRows + 1;
      newPageNum = Math.floor(index / newRows);
    }

    const newParams = { ...params, count: newRows, page: newPageNum };

    getParticipants(newParams);
    setParams(newParams);
  };

  const handleParticipantOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getParticipants(newParams);
    setParams(newParams);
  };

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

      params={params}
      handleParticipantPagination={handleParticipantPagination}
      handleParticipantOrdering={handleParticipantOrdering}
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
  session: selectSession(),
  users: selectPaginatedUsers(),
  loggedUser: selectUserSession(),

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
)(Conditional(
  SessionPage,
  ['session.permissions.update?', 'isFetchingSession'],
  (props, params) => ROUTES.user.root.path(),
  permissionMessages.mentorship.session.showPage
));
