import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/Email/Event/reducer';
import saga from 'containers/GlobalSettings/Email/Event/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectFormEvent, selectIsCommitting, selectIsFetchingEvent } from 'containers/GlobalSettings/Email/Event/selectors';

import {
  getEventBegin, updateEventBegin,
  eventsUnmount
} from 'containers/GlobalSettings/Email/Event/actions';

import EventForm from 'components/GlobalSettings/Email/EventForm';

export function EventEditPage(props) {
  useInjectReducer({ key: 'mailEvents', reducer });
  useInjectSaga({ key: 'mailEvents', saga });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.admin.system.globalSettings.mailEvents.index.path(),
    eventEdit: ROUTES.admin.system.globalSettings.mailEvents.edit.path(rs.params('event_id')),
  };

  useEffect(() => {
    const eventId = rs.params('event_id');
    props.getEventBegin({ id: eventId });

    return () => props.eventsUnmount();
  }, []);

  const { currentEvent } = props;

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
};

const mapStateToProps = createStructuredSelector({
  currentEvent: selectFormEvent(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingEvent(),
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
