import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectEvent } from 'containers/Event/selectors';

import {
  getEventBegin, updateEventBegin,
  eventsUnmount
} from 'containers/Event/actions';

import EventForm from 'components/Event/EventForm';

export function EventEditPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
    eventShow: ROUTES.group.events.show.path(rs.params('group_id'), rs.params('event_id')),
  };

  useEffect(() => {
    const eventId = rs.params('event_id');
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, []);

  const { currentUser, currentGroup, currentEvent } = props;

  return (
    <EventForm
      eventAction={props.updateEventBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      event={currentEvent}
      links={links}
    />
  );
}

EventEditPage.propTypes = {
  getEventBegin: PropTypes.func,
  updateEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentEvent: selectEvent(),
});

const mapDispatchToProps = {
  getEventBegin,
  updateEventBegin,
  eventsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EventEditPage);
