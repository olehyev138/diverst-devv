import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/Session/reducer';
import saga from 'containers/Mentorship/Session/saga';

import {
  selectPaginatedSessions,
  selectSessionsTotal,
  selectIsFetchingSessions,
  selectHasChanged
} from 'containers/Mentorship/Session/selectors';
import {
  getHostingSessionsBegin, getParticipatingSessionsBegin,
  sessionsUnmount, deleteSessionBegin,
} from 'containers/Mentorship/Session/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import SessionsList from 'components/Mentorship/SessionsList';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

const SessionTypes = Object.freeze({
  upcoming: 2,
  ongoing: 1,
  past: 0,
});

function tabToScope(tab) {
  switch (tab) {
    case 0:
      return ['past'];
    case 1:
      return ['ongoing'];
    case 2:
      return ['upcoming'];
    default:
      return [];
  }
}

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in SessionsList
  page: 0,
  order: 'desc',
  orderBy: 'mentoring_sessions.start',
});

export function SessionsPage(props) {
  useInjectReducer({ key: 'sessions', reducer });
  useInjectSaga({ key: 'sessions', saga });

  const { user, type } = props;

  const links = {
    sessionEdit: id => ROUTES.user.mentorship.sessions.edit.path(id),
    sessionShow: id => ROUTES.user.mentorship.sessions.show.path(id)
  };

  const [tab, setTab] = useState(SessionTypes.upcoming);
  const [params, setParams] = useState(defaultParams);

  const getSessions = (scopes, resetParams = false) => {
    const id = dig(props, 'user', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (id) {
      const newParams = {
        ...params,
        userId: id,
        query_scopes: scopes
      };
      if (type === 'hosting')
        props.getHostingSessionsBegin({ ...newParams });
      else if (type === 'participating')
        props.getParticipatingSessionsBegin({ ...newParams });
      setParams(newParams);
    }
  };

  useEffect(() => {
    getSessions(['upcoming']);

    return () => {
      props.sessionsUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      getSessions(tabToScope(tab));

    return () => {
      props.sessionsUnmount();
    };
  }, [props.hasChanged]);

  const handleChangeTab = (session, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case SessionTypes.upcoming:
        getSessions(['upcoming'], true);
        break;
      case SessionTypes.ongoing:
        getSessions(['ongoing'], true);
        break;
      case SessionTypes.past:
        getSessions(['past'], true);
        break;
      default:
        break;
    }
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getHostingSessionsBegin({ ...newParams, userId: user.id });
    setParams(newParams);
  };

  return (
    <SessionsList
      user={props.user}
      userSession={props.userSession}
      type={type}
      sessions={props.sessions}
      sessionsTotal={props.sessionsTotal}
      isLoading={props.isLoading}
      currentTab={tab}
      handleChangeTab={handleChangeTab}
      handlePagination={handlePagination}
      links={links}
      readonly={false}
      deleteAction={props.deleteSessionBegin}
    />
  );
}

SessionsPage.propTypes = {
  user: PropTypes.object.isRequired,
  userSession: PropTypes.shape({
    id: PropTypes.number
  }).isRequired,
  getHostingSessionsBegin: PropTypes.func.isRequired,
  getParticipatingSessionsBegin: PropTypes.func.isRequired,
  type: PropTypes.string.isRequired,
  sessionsUnmount: PropTypes.func.isRequired,
  deleteSessionBegin: PropTypes.func.isRequired,
  hasChanged: PropTypes.bool,
  sessions: PropTypes.array,
  sessionsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  sessions: selectPaginatedSessions(),
  sessionsTotal: selectSessionsTotal(),
  isLoading: selectIsFetchingSessions(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getHostingSessionsBegin,
  sessionsUnmount,
  getParticipatingSessionsBegin,
  deleteSessionBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  SessionsPage,
  ['user.permissions.update?'],
  (props, params) => ROUTES.user.root.path(),
  permissionMessages.mentorship.session.indexPage
));
