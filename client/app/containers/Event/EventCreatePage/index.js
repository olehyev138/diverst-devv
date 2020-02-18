import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createEventBegin, eventsUnmount } from 'containers/Event/actions';
import EventForm from 'components/Event/EventForm';
import { selectIsCommitting } from 'containers/Event/selectors';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/messages';

export function EventCreatePage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const { currentUser, currentGroup } = props;
  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
  };

  useEffect(() => () => props.eventsUnmount(), []);

  return (
    <EventForm
      eventAction={props.createEventBegin}
      isCommitting={props.isCommitting}
      buttonText={<DiverstFormattedMessage {...messages.create} />}
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
    />
  );
}

EventCreatePage.propTypes = {
  createEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createEventBegin,
  eventsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EventCreatePage);
