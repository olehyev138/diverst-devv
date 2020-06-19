import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams, useLocation } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { createEventBegin, eventsUnmount } from 'containers/Event/actions';
import EventForm from 'components/Event/EventForm';
import { selectIsCommitting } from 'containers/Event/selectors';

import messages from 'containers/Event/messages';
import { injectIntl, intlShape } from 'react-intl';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function EventCreatePage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const { group_id: groupId } = useParams();
  const location = useLocation();

  const { currentUser, currentGroup } = props;
  const links = {
    eventsIndex: ROUTES.group.events.index.path(groupId),
  };
  const { intl } = props;
  const pillar = location.state ? location.state.pillar : null;

  return (
    <React.Fragment>
      <DiverstBreadcrumbs />
      <EventForm
        eventAction={props.createEventBegin}
        isCommitting={props.isCommitting}
        buttonText={intl.formatMessage(messages.create)}
        currentUser={currentUser}
        currentGroup={currentGroup}
        links={links}
        pillar={pillar}
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
  location: PropTypes.object
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
  (props, params) => ROUTES.group.events.index.path(params.group_id),
  permissionMessages.event.createPage
));
