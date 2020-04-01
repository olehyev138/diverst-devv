import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/Outcome/reducer';
import saga from 'containers/Group/Outcome/saga';

import { selectPaginatedOutcomes, selectOutcomesTotal, selectIsLoading } from 'containers/Group/Outcome/selectors';
import { getOutcomesBegin, deleteOutcomeBegin, outcomesUnmount } from 'containers/Group/Outcome/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupPlanLayout from 'containers/Layouts/GroupPlanLayout';
import OutcomesList from 'components/Group/Outcome/OutcomesList';
import Conditional from 'components/Compositions/Conditional';

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
  const groupId = dig(props.currentGroup, 'id');

  const rs = new RouteService(useContext);
  const links = {
    outcomesIndex: ROUTES.group.plan.outcomes.index.path(rs.params('group_id')),
    outcomeNew: ROUTES.group.plan.outcomes.new.path(rs.params('group_id')),
    outcomeEdit: id => ROUTES.group.plan.outcomes.edit.path(rs.params('group_id'), id),
    eventIndex: ROUTES.group.plan.events.index.path(rs.params('group_id')),
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
  (props, rs) => ROUTES.group.plan.index.path(rs.params('group_id')),
  'You don\'t have permission to manage group outcomes'
));
