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
  useInjectReducer({ key: 'event', reducer });
  useInjectSaga({ key: 'event', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventFeedIndex: ROUTES.group.events.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const eventItemId = rs.params('item_id');
    props.getEventItemBegin({ id: eventItemId });

    return () => props.eventFeedUnmount();
  }, []);

  const { currentUser, currentGroup, currentEventItem } = props;

  return (
    <EventForm
      eventAction={props.updateEventBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      eventItem={currentEventItem}
      links={links}
    />
  );
}

EventEditPage.propTypes = {
  getEventItemBegin: PropTypes.func,
  updateEventBegin: PropTypes.func,
  eventFeedUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEventItem: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentEventItem: selectEvent(),
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
