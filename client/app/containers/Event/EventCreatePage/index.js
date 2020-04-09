import React, { memo, useContext, useEffect } from 'react';
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

import messages from 'containers/Event/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function EventCreatePage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  useEffect(() => () => {}, []);

  const { currentUser, currentGroup } = props;
  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
  };
  const { intl } = props;

  return (
    <React.Fragment>
      <EventForm
        eventAction={props.createEventBegin}
        isCommitting={props.isCommitting}
        buttonText={intl.formatMessage(messages.create)}
        currentUser={currentUser}
        currentGroup={currentGroup}
        links={links}
      />
    </React.Fragment>
  );
}

EventCreatePage.propTypes = {
  intl: intlShape,
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  EventCreatePage,
  ['currentGroup.permissions.events_create?'],
  (props, rs) => ROUTES.group.events.index.path(rs.params('group_id')),
  permissionMessages.event.createPage
));
