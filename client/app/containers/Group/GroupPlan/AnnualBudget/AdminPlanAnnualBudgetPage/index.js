/**
 *
 * AdminAnnualBudgetPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal, selectGroupIsLoading, selectHasChanged } from 'containers/Group/selectors';

import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import { getAnnualBudgetsBegin, groupListUnmount, carryBudgetBegin, resetBudgetBegin } from 'containers/Group/actions';

import AnnualBudgetList from 'components/Group/GroupPlan/AdminAnnualBudgetList';

export function AdminAnnualBudgetPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [params, setParams] = useState({ count: 10, page: 0, order: 'asc' });

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };


  useEffect(() => {
    props.getAnnualBudgetsBegin(params);

    return () => props.groupListUnmount();
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      props.getAnnualBudgetsBegin(params);

    return () => props.groupListUnmount();
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };

  return (
    <AnnualBudgetList
      isLoading={props.isLoading}
      annualBudgets={props.groups}
      annualBudgetTotal={props.groupTotal}
      defaultParams={params}
      handlePagination={handlePagination}
      handleOrdering={handleOrdering}
      carryBudget={props.carryBudgetBegin}
      resetBudget={props.resetBudgetBegin}
    />
  );
}

AdminAnnualBudgetPage.propTypes = {
  getAnnualBudgetsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  carryBudgetBegin: PropTypes.func.isRequired,
  resetBudgetBegin: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  hasChanged: PropTypes.bool,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupIsLoading(),
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getAnnualBudgetsBegin,
  carryBudgetBegin,
  resetBudgetBegin,
  groupListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AdminAnnualBudgetPage);
