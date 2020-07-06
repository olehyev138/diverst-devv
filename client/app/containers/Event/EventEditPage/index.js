import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectFormEvent, selectIsCommitting, selectIsFormLoading } from 'containers/Event/selectors';

import { eventsUnmount, getEventBegin, updateEventBegin } from 'containers/Event/actions';

import EventForm from 'components/Event/EventForm';

import messages from 'containers/Event/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function EventEditPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const { group_id: groupId, event_id: eventId } = useParams();
  const links = {
    eventsIndex: ROUTES.group.events.index.path(groupId),
    eventShow: ROUTES.group.events.show.path(groupId, eventId),
  };
  const { intl } = props;
  useEffect(() => {
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, []);

  const { currentUser, currentGroup, currentEvent } = props;

  return (
    <EventForm
      edit
      eventAction={props.updateEventBegin}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      buttonText={intl.formatMessage(messages.update)}
      currentUser={currentUser}
      currentGroup={currentGroup}
      event={currentEvent}
      links={links}
    />
  );
}

EventEditPage.propTypes = {
  intl: intlShape.isRequired,
  getEventBegin: PropTypes.func,
  updateEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentEvent: selectFormEvent(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  EventEditPage,
  ['currentEvent.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.group.events.show.path(params.group_id, params.event_id),
  permissionMessages.event.editPage
));
