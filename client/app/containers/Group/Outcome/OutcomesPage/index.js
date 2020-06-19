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

import { selectPaginatedOutcomes, selectOutcomesTotal, selectIsLoading } from 'containers/Group/Outcome/selectors';
import { getOutcomesBegin, deleteOutcomeBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import OutcomesList from 'components/Group/Outcome/OutcomesList';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

const defaultParams = Object.freeze({
  count: 10,
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function OutcomesPage(props) {
  useInjectReducer({ key: 'outcomes', reducer });
  useInjectSaga({ key: 'outcomes', saga });

  const [params, setParams] = useState(defaultParams);

  const { group_id: groupId } = useParams();

  const links = {
    outcomesIndex: ROUTES.group.plan.outcomes.index.path(groupId),
    outcomeNew: ROUTES.group.plan.outcomes.new.path(groupId),
    outcomeEdit: id => ROUTES.group.plan.outcomes.edit.path(groupId, id),
    eventIndex: ROUTES.group.plan.events.index.path(groupId),
  };

  useEffect(() => {
    if (groupId)
      props.getOutcomesBegin({ ...params, group_id: groupId });

    return () => props.outcomesUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = {
      ...params,
      count: payload.count,
      page: payload.page
    };

    props.getOutcomesBegin({ ...newParams, group_id: groupId });
    setParams(newParams);
  };

  return (
    <OutcomesList
      outcomes={props.outcomes}
      outcomesTotal={props.outcomesTotal}
      isLoading={props.isLoading}
      deleteOutcomeBegin={props.deleteOutcomeBegin}
      defaultParams={defaultParams}
      handlePagination={handlePagination}
      links={links}
    />
  );
}

OutcomesPage.propTypes = {
  getOutcomesBegin: PropTypes.func.isRequired,
  deleteOutcomeBegin: PropTypes.func.isRequired,
  outcomesUnmount: PropTypes.func.isRequired,
  outcomes: PropTypes.array,
  outcomesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  outcomes: selectPaginatedOutcomes(),
  outcomesTotal: selectOutcomesTotal(),
  isLoading: selectIsLoading(),
});

const mapDispatchToProps = {
  getOutcomesBegin,
  deleteOutcomeBegin,
  outcomesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  OutcomesPage,
  ['currentGroup.permissions.update?'],
  (props, params) => ROUTES.group.plan.index.path(params.group_id),
  permissionMessages.group.outcome.indexPage
));
