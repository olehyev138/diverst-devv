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
import { selectUser, selectCustomText } from 'containers/Shared/App/selectors';
import { selectEvent, selectHasChanged, selectIsFormLoading } from 'containers/Event/selectors';
import { redirectAction } from 'utils/reduxPushHelper';
import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  archiveEventBegin,
  createEventCommentBegin,
  deleteEventBegin,
  deleteEventCommentBegin,
  eventsUnmount,
  getEventBegin,
  joinEventBegin,
  leaveEventBegin,
  exportAttendeesBegin
} from 'containers/Event/actions';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Event from 'components/Event/Event';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Shared/App/messages';

export function EventPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const { group_id: groupId, event_id: eventId } = useParams();

  const links = {
    eventsIndex: ROUTES.group.events.index.path(groupId),
    eventEdit: ROUTES.group.events.edit.path(groupId, eventId)
  };

  useEffect(() => {
    // eslint-disable-next-line eqeqeq
    if (props.currentEvent && props.currentEvent.group_id != groupId && !props.currentEvent.participating_groups.find(g => g.id == groupId)) {
      props.redirectAction(links.eventsIndex);
      props.showSnackbar({
        message: messages.errors.invalidURL,
        options: { variant: 'warning' }
      });
    }
  }, [props.currentEvent]);

  useEffect(() => {
    // get event specified in path
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, [props.hasChanged]);

  const { currentUser, currentEvent } = props;
  return (
    <React.Fragment>
      <DiverstBreadcrumbs customTexts={props.customTexts} />
      <Event
        currentUserId={currentUser.user_id}
        createEventCommentBegin={props.createEventCommentBegin}
        deleteEventCommentBegin={props.deleteEventCommentBegin}
        deleteEventBegin={props.deleteEventBegin}
        event={currentEvent}
        links={links}
        isFormLoading={props.isFormLoading}
        archiveEventBegin={props.archiveEventBegin}
        joinEventBegin={props.joinEventBegin}
        leaveEventBegin={props.leaveEventBegin}
        hasChanged={props.hasChanged}
        currentGroup={props.currentGroup}
        export={props.exportAttendeesBegin}
        customTexts={props.customTexts}
      />
    </React.Fragment>
  );
}

EventPage.propTypes = {
  getEventBegin: PropTypes.func,
  deleteEventBegin: PropTypes.func,
  archiveEventBegin: PropTypes.func,
  joinEventBegin: PropTypes.func,
  leaveEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,
  isFormLoading: PropTypes.bool,
  createEventCommentBegin: PropTypes.func,
  deleteEventCommentBegin: PropTypes.func,
  exportAttendeesBegin: PropTypes.func,
  hasChanged: PropTypes.bool,
  redirectAction: PropTypes.func,
  showSnackbar: PropTypes.func,
  customTexts: PropTypes.object,
  intl: intlShape,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentEvent: selectEvent(),
  isFormLoading: selectIsFormLoading(),
  hasChanged: selectHasChanged(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  getEventBegin,
  deleteEventBegin,
  createEventCommentBegin,
  deleteEventCommentBegin,
  archiveEventBegin,
  eventsUnmount,
  joinEventBegin,
  leaveEventBegin,
  exportAttendeesBegin,
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  injectIntl,
  memo,
)(Conditional(
  EventPage,
  ['currentEvent.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.group.events.index.path(params.group_id),
  permissionMessages.event.showPage
));
