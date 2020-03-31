import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectPaginatedOutcomes, selectOutcomesTotal, selectIsLoading } from 'containers/Group/Outcome/selectors';

import { getOutcomesBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import EventsList from 'components/Group/GroupPlan/EventsList';
import GroupPlanLayout from 'containers/Layouts/GroupPlanLayout';

export function EventsPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const rs = new RouteService(useContext);

  const defaultParams = Object.freeze({
    group_id: rs.params('group_id'),
    count: 2,
    page: 0,
  });

  const links = {
    outcomeIndex: ROUTES.group.plan.outcomes.index.path(rs.params('group_id')),
    eventNew: ROUTES.group.events.new.path(rs.params('group_id')),
    eventManage: eventId => ROUTES.group.plan.events.manage.updates.index.path(rs.params('group_id'), eventId)
  };

  const [params, setParams] = useState(defaultParams);

  useEffect(() => {
    props.getOutcomesBegin(params);

    return () => props.outcomesUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = {
      ...params,
      count: payload.count,
      page: payload.page
    };

    props.getOutcomesBegin(newParams);
    setParams(newParams);
  };

  const { outcomes, outcomesTotal, isLoading } = props;

  return (
    <EventsList
      outcomes={outcomes}
      outcomesTotal={outcomesTotal}
      currentGroup={props.currentGroup}
      links={links}
      isLoading={isLoading}
      handlePagination={handlePagination}
      params={params}
      rowsPerPageOptions={[1, 2, 3, 5]}
    />
  );
}

EventsPage.propTypes = {
  getOutcomesBegin: PropTypes.func,
  outcomesUnmount: PropTypes.func,
  outcomes: PropTypes.array,
  outcomesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  outcomes: selectPaginatedOutcomes(),
  outcomesTotal: selectOutcomesTotal(),
  isLoading: selectIsLoading(),
});

const mapDispatchToProps = {
  getOutcomesBegin,
  outcomesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EventsPage);
