import React, { memo, useContext, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import Conditional from 'components/Compositions/Conditional';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import { selectEventsTotal, selectIsLoading, selectPaginatedEvents } from 'containers/Event/selectors';
import { eventsUnmount, getEventsBegin } from 'containers/Event/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import EventsList from 'components/Event/EventsList';

const EventTypes = Object.freeze({
  upcoming: 0,
  ongoing: 1,
  past: 2,
});

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'start',
});

export function EventsPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
    eventShow: id => ROUTES.group.events.show.path(rs.params('group_id'), id),
    eventNew: ROUTES.group.events.new.path(rs.params('group_id')),
    eventEdit: id => ROUTES.group.events.edit.path(rs.params('group_id'), id)
  };

  const [tab, setTab] = useState(EventTypes.upcoming);
  const [params, setParams] = useState(defaultParams);

  const getEvents = (scopes, resetParams = false) => {
    const id = dig(props, 'currentGroup', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (id) {
      const newParams = {
        ...params,
        group_id: id,
        query_scopes: scopes
      };
      props.getEventsBegin(newParams);
      setParams(newParams);
    }
  };

  useEffect(() => {
    getEvents(['upcoming', 'not_archived']);

    return () => {
      props.eventsUnmount();
    };
  }, []);

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case EventTypes.upcoming:
        getEvents(['upcoming', 'not_archived'], true);
        break;
      case EventTypes.ongoing:
        getEvents(['ongoing', 'not_archived'], true);
        break;
      case EventTypes.past:
        getEvents(['past', 'not_archived'], true);
        break;
      default:
        break;
    }
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getEventsBegin(newParams);
    setParams(newParams);
  };

  return (
    <EventsList
      events={props.events}
      eventsTotal={props.eventsTotal}
      isLoading={props.isLoading}
      currentTab={tab}
      handleChangeTab={handleChangeTab}
      handlePagination={handlePagination}
      currentGroup={props.currentGroup}
      links={links}
      readonly={props.readonly}
    />
  );
}

EventsPage.propTypes = {
  getEventsBegin: PropTypes.func.isRequired,
  eventsUnmount: PropTypes.func.isRequired,
  events: PropTypes.array,
  eventsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
  readonly: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  events: selectPaginatedEvents(),
  eventsTotal: selectEventsTotal(),
  isLoading: selectIsLoading(),
});

const mapDispatchToProps = {
  getEventsBegin,
  eventsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  EventsPage,
  ['currentGroup.permissions.events_view?'],
  (props, rs) => props.readonly ? null : ROUTES.group.home.path(rs.params('group_id')),
  'You don\'t have permission view this group\'s events'
));
