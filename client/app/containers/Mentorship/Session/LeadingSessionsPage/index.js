import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Mentorship/Session/reducer';
import saga from 'containers/Mentorship/Session/saga';

import { selectPaginatedSessions, selectSessionsTotal, selectIsFetchingSessions } from 'containers/Mentorship/Session/selectors';
import { getLeadingSessionsBegin, sessionsUnmount } from 'containers/Mentorship/Session/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import SessionsList from 'components/Mentorship/SessionsList';

const SessionTypes = Object.freeze({
  upcoming: 0,
  ongoing: 1,
  past: 2,
});

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in SessionsList
  page: 0,
  order: 'desc',
  orderBy: 'start',
});

export function SessionsPage(props) {
  useInjectReducer({ key: 'sessions', reducer });
  useInjectSaga({ key: 'sessions', saga });

  const { user } = props;

  const rs = new RouteService(useContext);
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
      props.getLeadingSessionsBegin({ ...newParams });
      setParams(newParams);
    }
  };

  useEffect(() => {
    getSessions(['upcoming']);

    return () => {
      props.sessionsUnmount();
    };
  }, []);

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

    props.getLeadingSessionsBegin({ ...newParams, userId: user.id });
    setParams(newParams);
  };

  return (
    <SessionsList
      sessions={props.sessions}
      sessionsTotal={props.sessionsTotal}
      isLoading={props.isLoading}
      currentTab={tab}
      handleChangeTab={handleChangeTab}
      handlePagination={handlePagination}
      links={links}
      readonly={false}
    />
  );
}

SessionsPage.propTypes = {
  user: PropTypes.object.isRequired,
  getLeadingSessionsBegin: PropTypes.func.isRequired,
  sessionsUnmount: PropTypes.func.isRequired,
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
});

const mapDispatchToProps = {
  getLeadingSessionsBegin,
  sessionsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SessionsPage);
