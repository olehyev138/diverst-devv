import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import { selectEventsTotal, selectIsLoading, selectPaginatedEvents, selectCalendarEvents } from 'containers/Event/selectors';
import { eventsUnmount, getEventsBegin } from 'containers/Event/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import EventsList from 'components/Event/EventsList';
import Conditional from 'components/Compositions/Conditional';

import permissionMessages from 'containers/Shared/Permissions/messages';

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

  const { group_id: groupId } = useParams();
  const links = {
    eventsIndex: ROUTES.group.events.index.path(groupId),
    eventShow: id => ROUTES.group.events.show.path(groupId, id),
    eventNew: ROUTES.group.events.new.path(groupId),
    eventEdit: id => ROUTES.group.events.edit.path(groupId, id)
  };

  const [tab, setTab] = useState(EventTypes.upcoming);
  const [dateRange, setDateRange] = useState([]);
  const [params, setParams] = useState(defaultParams);
  const [calendar, setCalendar] = useState(null);

  const getEvents = (scopes = null, resetParams = false) => {
    const id = dig(props, 'currentGroup', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (id) {
      let newParams;
      if (calendar)
        newParams = {
          ...params,
          group_id: id,
          query_scopes: ['not_archived', ['date_range', ...dateRange]],
          count: -1
        };
      else
        newParams = {
          ...params,
          group_id: id,
          query_scopes: scopes || params.query_scopes
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

  useEffect(() => {
    if (calendar != null)
      getEvents();
  }, [dateRange]);

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

  const handleCalendarPage = (start, end) => {
    setDateRange([start, end]);
  };

  const handleChangeCalendar = () => {
    setCalendar(!calendar);
    if (calendar) // was calendar noe list
      setDateRange([]);
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getEventsBegin(newParams);
    setParams(newParams);
  };

  const List = props.listComponent || EventsList;

  return (
    <React.Fragment>
      {!props.readonly && (
        <DiverstBreadcrumbs />
      )}
      <List
      events={props.events}
      eventsTotal={props.eventsTotal}
      isLoading={props.isLoading}
      currentTab={tab}
      handleChangeTab={handleChangeTab}
      handlePagination={handlePagination}
      handleCalendarChange={handleChangeCalendar}
      calendar={calendar}
      calendarEvents={props.calendarEvents}
      currentGroup={props.currentGroup}
      links={links}
      readonly={props.readonly}
      onlyUpcoming={props.onlyUpcoming}
      calendarDateCallback={handleCalendarPage}
      currentGroupID={props.currentGroup.id}
    /></React.Fragment>
  );
}

EventsPage.propTypes = {
  getEventsBegin: PropTypes.func.isRequired,
  eventsUnmount: PropTypes.func.isRequired,
  events: PropTypes.array,
  calendarEvents: PropTypes.array,
  eventsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
  readonly: PropTypes.bool,
  onlyUpcoming: PropTypes.bool,
  listComponent: PropTypes.elementType,
};

const mapStateToProps = createStructuredSelector({
  events: selectPaginatedEvents(),
  calendarEvents: selectCalendarEvents(),
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
  (props, params) => props.readonly ? null : ROUTES.group.home.path(params.group_id),
  permissionMessages.event.indexPage
));
