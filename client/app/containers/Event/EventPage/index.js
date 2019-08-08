import React, { memo, useEffect, useContext } from 'react';
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

import { getEventBegin, eventsUnmount } from 'containers/Event/actions';

import Event from 'components/Event/Event';

export function EventPage(props) {
  useInjectReducer({ key: 'event', reducer });
  useInjectSaga({ key: 'event', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const eventId = rs.params('event_id');

    // get event item & comments specified in path
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, []);

  const { currentUser, currentEvent } = props;

  return (
    <Event
      currentUserId={currentUser.id}
      event={currentEvent}
      links={links}
    />
  );
}

EventPage.propTypes = {
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
  eventsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EventPage);
