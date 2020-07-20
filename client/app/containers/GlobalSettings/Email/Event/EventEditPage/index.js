import React, {
  memo, useEffect
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/Email/Event/reducer';
import saga from 'containers/GlobalSettings/Email/Event/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectFormEvent, selectIsCommitting, selectIsFetchingEvent } from 'containers/GlobalSettings/Email/Event/selectors';

import {
  getEventBegin, updateEventBegin,
  eventsUnmount
} from 'containers/GlobalSettings/Email/Event/actions';

import EventForm from 'components/GlobalSettings/Email/EventForm';
import messages from 'containers/GlobalSettings/Email/Event/messages';
import globalMessages from 'containers/Shared/App/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function EventEditPage(props) {
  useInjectReducer({ key: 'mailEvents', reducer });
  useInjectSaga({ key: 'mailEvents', saga });

  const { event_id: eventId } = useParams();
  const links = {
    eventsIndex: ROUTES.admin.system.globalSettings.emails.events.index.path(),
    eventEdit: ROUTES.admin.system.globalSettings.emails.events.edit.path(eventId),
  };

  const { currentEvent, intl } = props;

  const mapDay = (day) => {
    if (day.label >= 0)
      day.label = intl.formatMessage(globalMessages.days_of_week[day.label]);
    else
      day.label = intl.formatMessage(messages.everyday);

    return day;
  };

  useEffect(() => {
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, []);

  if (currentEvent)
    mapDay(currentEvent.day, intl);

  return (
    <EventForm
      edit
      eventAction={props.updateEventBegin}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      event={currentEvent}
      links={links}
    />
  );
}

EventEditPage.propTypes = {
  getEventBegin: PropTypes.func,
  updateEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentEvent: PropTypes.object,
  currentEnterprise: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,

  intl: intlShape.isRequired,
};

const mapStateToProps = createStructuredSelector({
  currentEvent: selectFormEvent(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingEvent(),
  permissions: selectPermissions(),
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
  injectIntl,
  memo,
)(Conditional(
  EventEditPage,
  ['permissions.emails_manage'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.globalSettings.email.event.editPage
));
