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
import { selectHasChanged as budgetHasChanged } from 'containers/Group/GroupPlan/AnnualBudget/selectors';

import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import { getAnnualBudgetsBegin, groupAllUnmount, carryBudgetBegin, resetBudgetBegin } from 'containers/Group/actions';
import { resetAnnualBudgetBegin } from 'containers/Group/GroupPlan/AnnualBudget/actions';

import AnnualBudgetList from 'components/Group/GroupPlan/AdminAnnualBudgetList';
import { push } from 'connected-react-router';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Conditional from 'components/Compositions/Conditional';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import annualBudgetReducer from 'containers/Group/GroupPlan/AnnualBudget/reducer';
import annualBudgetSaga from 'containers/Group/GroupPlan/AnnualBudget/saga';

const handleVisitEditPage = groupId => push(ROUTES.group.plan.budget.editAnnualBudget.path(groupId));

export function AdminAnnualBudgetPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  useInjectReducer({ key: 'annualBudgets', reducer: annualBudgetReducer });
  useInjectSaga({ key: 'annualBudgets', saga: annualBudgetSaga });

  const [params, setParams] = useState({ count: 10, page: 0, order: 'asc', query_scopes: ['all_parents'] });

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };

  const handleSearching = (searchText) => {
    const newParams = { ...params, search: searchText };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };


  useEffect(() => {
    props.getAnnualBudgetsBegin(params);

    return () => props.groupAllUnmount();
  }, []);

  useEffect(() => {
    if (props.hasChanged || props.budgetHasChanged)
      props.getAnnualBudgetsBegin(params);

    return () => props.groupAllUnmount();
  }, [props.hasChanged, props.budgetHasChanged]);

  return (
    <AnnualBudgetList
      isFetchingAnnualBudgets={props.isFetchingAnnualBudgets}
      annualBudgets={props.groups}
      annualBudgetTotal={props.groupTotal}
      defaultParams={params}
      handlePagination={handlePagination}
      handleOrdering={handleOrdering}
      handleSearching={handleSearching}
      carryBudget={props.carryBudgetBegin}
      resetBudget={props.resetBudgetBegin}
      resetAll={props.resetAnnualBudgetBegin}
      handleVisitEditPage={props.handleVisitEditPage}
    />
  );
}

AdminAnnualBudgetPage.propTypes = {
  getAnnualBudgetsBegin: PropTypes.func.isRequired,
  groupAllUnmount: PropTypes.func.isRequired,
  carryBudgetBegin: PropTypes.func.isRequired,
  resetBudgetBegin: PropTypes.func.isRequired,
  handleVisitEditPage: PropTypes.func.isRequired,
  isFetchingAnnualBudgets: PropTypes.bool,
  enterprise: PropTypes.object,
  hasChanged: PropTypes.bool,
  budgetHasChanged: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  resetAnnualBudgetBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  isFetchingAnnualBudgets: selectGroupIsLoading(),
  enterprise: selectEnterprise(),
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  hasChanged: selectHasChanged(),
  budgetHasChanged: budgetHasChanged(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getAnnualBudgetsBegin,
  carryBudgetBegin,
  resetBudgetBegin,
  groupAllUnmount,
  resetAnnualBudgetBegin,
  handleVisitEditPage,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  AdminAnnualBudgetPage,
  ['permissions.manage_all_budgets', 'enterprise.plan_module_enabled'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.group.groupPlan.annualBudget.adminPlanPage,
  false,
  permissions => permissions.every(a => a)
));
