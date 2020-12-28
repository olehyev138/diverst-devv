import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectPaginatedOutcomes, selectOutcomesTotal, selectIsLoading } from 'containers/Group/Outcome/selectors';
import { selectCustomText } from 'containers/Shared/App/selectors';

import { getOutcomesBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import EventsList from 'components/Group/GroupPlan/EventsList';

export function EventsPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const { group_id: groupId } = useParams();

  const defaultParams = Object.freeze({
    group_id: groupId,
    count: 2,
    page: 0,
  });

  const links = {
    outcomeIndex: ROUTES.group.plan.outcomes.index.path(groupId),
    eventNew: ROUTES.group.events.new.path(groupId),
    eventManage: eventId => ROUTES.group.plan.events.manage.updates.index.path(groupId, eventId)
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
      customTexts={props.customTexts}
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
  customTexts: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
  outcomes: selectPaginatedOutcomes(),
  outcomesTotal: selectOutcomesTotal(),
  isLoading: selectIsLoading(),
  customTexts: selectCustomText(),
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
