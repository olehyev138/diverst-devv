import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import pillarReducer from 'containers/Group/Pillar/reducer';
import pillarSaga from 'containers/Group/Pillar/saga';
import budgetItemReducer from 'containers/Group/GroupPlan/BudgetItem/reducer';
import budgetItemSaga from 'containers/Group/GroupPlan/BudgetItem/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createEventBegin, eventsUnmount } from 'containers/Event/actions';
import EventForm from 'components/Event/EventForm';
import { selectIsCommitting } from 'containers/Event/selectors';

export function EventCreatePage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });
  useInjectReducer({ key: 'pillars', reducer: pillarReducer });
  useInjectSaga({ key: 'pillars', saga: pillarSaga });
  useInjectReducer({ key: 'budgetItems', reducer: budgetItemReducer });
  useInjectSaga({ key: 'budgetItems', saga: budgetItemSaga });

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
      buttonText='Create'
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
