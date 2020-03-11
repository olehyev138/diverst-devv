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
import { selectEvent, selectIsFormLoading } from 'containers/Event/selectors';

import { getEventBegin, deleteEventBegin, createEventCommentBegin, deleteEventCommentBegin, archiveEventBegin, eventsUnmount } from 'containers/Event/actions';

import Event from 'components/Event/Event';

export function EventPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
    eventEdit: ROUTES.group.events.edit.path(rs.params('group_id'), rs.params('event_id'))
  };

  useEffect(() => {
    const eventId = rs.params('event_id');

    // get event specified in path
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, []);

  const { currentUser, currentEvent } = props;

  return (
    <Event
      currentUserId={currentUser.user_id}
      createEventCommentBegin={props.createEventCommentBegin}
      deleteEventCommentBegin={props.deleteEventCommentBegin}
      deleteEventBegin={props.deleteEventBegin}
      event={currentEvent}
      links={links}
      isFormLoading={props.isFormLoading}
      archiveEventBegin={props.archiveEventBegin}
    />
  );
}

EventPage.propTypes = {
  getEventBegin: PropTypes.func,
  deleteEventBegin: PropTypes.func,
  archiveEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,
  isFormLoading: PropTypes.bool,
  createEventCommentBegin: PropTypes.func,
  deleteEventCommentBegin: PropTypes.func,

};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentEvent: selectEvent(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getEventBegin,
  deleteEventBegin,
  createEventCommentBegin,
  deleteEventCommentBegin,
  archiveEventBegin,
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
