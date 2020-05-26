import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';
import { getEventsBegin, eventsUnmount } from 'containers/Event/actions';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { selectIsLoading, selectCalendarEvents } from 'containers/Event/selectors';
import DiverstCalendar from 'components/Shared/DiverstCalendar';

const defaultParams = Object.freeze({
  count: -1, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'id',
  query_scopes: ['not_archived']
});

const ArchiveTypes = Object.freeze({
  posts: 0,
  resources: 1,
  events: 2,
});


export function AdminCalendarPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const [params, setParams] = useState(defaultParams);

  const getEvents = (updatedParams = {}) => {
    const newParams = {
      ...params,
      ...updatedParams,
    };
    props.getEventsBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    getEvents();
  }, []);

  const handleGroupFilter = (value) => {
    getEvents(value);
  };

  return (
    <DiverstCalendar
      events={props.events}
      groupLegend
      groupFilter
      groupFilterCallback={handleGroupFilter}
      isLoading={props.isLoading}
    />
  );
}

AdminCalendarPage.propTypes = {
  events: PropTypes.array,
  getEventsBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  isLoading: PropTypes.bool,
  permissions: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
  events: selectCalendarEvents(),
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
  AdminCalendarPage,
  ['permissions.groups_calendars'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.calendar.indexPage
));
