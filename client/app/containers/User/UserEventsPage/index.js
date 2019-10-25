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
import reducer from 'containers/User/reducer';
import saga from 'containers/User/saga';

import { selectPaginatedEvents, selectEventsTotal, selectIsLoadingEvents } from 'containers/User/selectors';
import { getUserEventsBegin, userUnmount } from 'containers/User/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import EventsList from 'components/Event/EventsList';

const EventTypes = Object.freeze({
  upcoming: 0,
  ongoing: 1,
  past: 2,
});

const ParticipationTypes = Object.freeze({
  participating: 0,
  all: 1,
});

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'desc',
  orderBy: 'start',
});

export function EventsPage(props) {
  useInjectReducer({ key: 'users', reducer });
  useInjectSaga({ key: 'users', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
    eventShow: id => ROUTES.group.events.show.path(rs.params('group_id'), id),
    eventNew: ROUTES.group.events.new.path(rs.params('group_id')),
    eventEdit: id => ROUTES.group.events.edit.path(rs.params('group_id'), id)
  };

  const [tab, setTab] = useState(EventTypes.upcoming);
  const [participateTab, setParticipateTab] = useState(ParticipationTypes.participating);
  const [params, setParams] = useState(defaultParams);

  const getEvents = (scopes = null, participation = null, resetParams = false) => {
    if (resetParams)
      setParams(defaultParams);

    if (participation == null)
      switch (participateTab) {
        case 0:
          // eslint-disable-next-line no-param-reassign
          participation = 'participation';
          break;
        case 1:
          // eslint-disable-next-line no-param-reassign
          participation = 'all';
          break;
        default:
          break;
      }

    if (scopes == null)
      switch (tab) {
        case 0:
          // eslint-disable-next-line no-param-reassign
          scopes = ['upcoming'];
          break;
        case 1:
          // eslint-disable-next-line no-param-reassign
          scopes = ['ongoing'];
          break;
        case 2:
          // eslint-disable-next-line no-param-reassign
          scopes = ['past'];
          break;
        default:
          break;
      }

    const newParams = {
      ...params,
      query_scopes: scopes,
      participation
    };
    props.getUserEventsBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    getEvents(['upcoming']);

    return () => {
      props.userUnmount();
    };
  }, []);

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case EventTypes.upcoming:
        getEvents(['upcoming'], null, true);
        break;
      case EventTypes.ongoing:
        getEvents(['ongoing'], null, true);
        break;
      case EventTypes.past:
        getEvents(['past'], null, true);
        break;
      default:
        break;
    }
  };

  const handleChangeParticipationTab = (event, newTab) => {
    setParticipateTab(newTab);
    switch (newTab) {
      case ParticipationTypes.participating:
        getEvents(null, 'participating', true);
        break;
      case ParticipationTypes.all:
        getEvents(null, 'all', true);
        break;
      default:
        break;
    }
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getUserEventsBegin(newParams);
    setParams(newParams);
  };

  return (
    <EventsList
      events={props.events}
      eventsTotal={props.eventsTotal}
      currentTab={tab}
      currentPTab={participateTab}
      handleChangePTab={handleChangeParticipationTab}
      handleChangeTab={handleChangeTab}
      handlePagination={handlePagination}
      isLoading={props.isLoading}
      links={links}
      loaderProps={props.loaderProps}
      readonly
    />
  );
}

EventsPage.propTypes = {
  getUserEventsBegin: PropTypes.func.isRequired,
  userUnmount: PropTypes.func.isRequired,
  events: PropTypes.array,
  eventsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  loaderProps: PropTypes.object,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  events: selectPaginatedEvents(),
  eventsTotal: selectEventsTotal(),
  isLoading: selectIsLoadingEvents(),
});

const mapDispatchToProps = {
  getUserEventsBegin,
  userUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EventsPage);
