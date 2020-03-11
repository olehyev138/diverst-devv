import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/GlobalSettings/Email/Event/saga';
import reducer from 'containers/GlobalSettings/Email/Event/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  selectPaginatedEvents,
  selectIsFetchingEvents,
  selectEventsTotal
} from 'containers/GlobalSettings/Email/Event/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import {
  eventsUnmount, getEventsBegin,
} from 'containers/GlobalSettings/Email/Event/actions';

import EventsList from 'components/GlobalSettings/Email/EventsList';
import globalMessages from 'containers/Shared/App/messages';
import messages from 'containers/GlobalSettings/Email/Event/messages';
import { injectIntl, intlShape } from 'react-intl';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function CustomTextEditPage(props) {
  useInjectReducer({ key: 'mailEvents', reducer });
  useInjectSaga({ key: 'mailEvents', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.admin.system.globalSettings.mailEvents.index.path(),
    eventEdit: id => ROUTES.admin.system.globalSettings.mailEvents.edit.path(id),
  };

  const { currentUser, events, isFetching, intl } = props;

  const mapDay = (event) => {
    if (event.day.label >= 0)
      event.day.label = intl.formatMessage(globalMessages.days_of_week[event.day.label]);
    else
      event.day.label = intl.formatMessage(messages.everyday);

    return event;
  };

  const [params, setParams] = useState(defaultParams);

  const getEvents = (newParams = params) => {
    const updatedParams = {
      ...params,
      ...newParams,
    };
    props.getEventsBegin(updatedParams);
    setParams(updatedParams);
  };

  useEffect(() => {
    getEvents();

    return () => {
      props.eventsUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getEvents(newParams);
  };

  return (
    <EventsList
      currentUser={currentUser}
      events={events.map(event => mapDay(event))}
      handlePagination={handlePagination}
      eventsTotal={props.eventsTotal}
      links={links}
      isLoading={isFetching}
    />
  );
}

CustomTextEditPage.propTypes = {
  getEventsBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  events: PropTypes.array,
  eventsTotal: PropTypes.number,
  isFetching: PropTypes.bool,

  intl: intlShape.isRequired,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  events: selectPaginatedEvents(),
  eventsTotal: selectEventsTotal(),
  isFetching: selectIsFetchingEvents(),
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
  injectIntl,
  memo,
)(CustomTextEditPage);