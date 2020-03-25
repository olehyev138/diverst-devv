import React, { memo, useContext, useEffect, useState } from 'react';
import dig from 'object-dig';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupPlan/Budget/reducer';
import saga from 'containers/Group/GroupPlan/Budget/saga';
import itemReducer from 'containers/Group/GroupPlan/BudgetItem/reducer';
import itemSaga from 'containers/Group/GroupPlan/BudgetItem/saga';

import {
  getBudgetBegin,
  getBudgetSuccess,
  budgetsUnmount,
  approveBudgetBegin,
  declineBudgetBegin
} from 'containers/Group/GroupPlan/Budget/actions';
import {
  closeBudgetItemsBegin
} from 'containers/Group/GroupPlan/BudgetItem/actions';
import { selectGroup } from 'containers/Group/selectors';
import {
  selectIsFetchingBudget,
  selectBudget,
  selectIsCommitting
} from 'containers/Group/GroupPlan/Budget/selectors';
import {
  selectHasChanged
} from 'containers/Group/GroupPlan/BudgetItem/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Budget from 'components/Group/GroupPlan/Budget';
import Conditional from 'components/Compositions/Conditional';

export function BudgetPage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });
  useInjectReducer({ key: 'budgetItems', reducer: itemReducer });
  useInjectSaga({ key: 'budgetItems', saga: itemSaga });

  const groupId = dig(props, 'budget', 'group_id');
  const annualBudgetId = dig(props, 'budget', 'annual_budget_id');

  const links = {
    back: ROUTES.group.plan.budget.budgets.index.path(groupId, annualBudgetId)
  };

  const rs = new RouteService(useContext);
  const budget = dig(props, 'budget') || rs.location.budget;

  useEffect(() => {
    const budgetId = rs.params('budget_id');
    // eslint-disable-next-line eqeqeq
    if (!budget || budget.id != budgetId)
      props.getBudgetBegin({ id: budgetId });
    else
      props.getBudgetSuccess({ budget });

    return () => props.budgetsUnmount();
  }, []);

  useEffect(() => {
    const budgetId = rs.params('budget_id');
    if (props.hasChanged)
      props.getBudgetBegin({ id: budgetId });

    return () => props.budgetsUnmount();
  }, [props.hasChanged]);

  return (
    <Budget
      budget={props.budget}
      approveAction={props.approveBudgetBegin}
      declineAction={props.declineBudgetBegin}
      closeBudgetAction={props.closeBudgetItemsBegin}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

BudgetPage.propTypes = {
  getBudgetBegin: PropTypes.func,
  getBudgetSuccess: PropTypes.func,
  budgetsUnmount: PropTypes.func,
  approveBudgetBegin: PropTypes.func,
  declineBudgetBegin: PropTypes.func,
  closeBudgetItemsBegin: PropTypes.func,

  currentGroup: PropTypes.object,
  budget: PropTypes.object,

  isLoading: PropTypes.bool,
  isCommitting: PropTypes.bool,
  hasChanged: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectIsFetchingBudget(),
  isCommitting: selectIsCommitting(),
  budget: selectBudget(),
  currentGroup: selectGroup(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getBudgetBegin,
  getBudgetSuccess,
  budgetsUnmount,
  approveBudgetBegin,
  declineBudgetBegin,
  closeBudgetItemsBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  BudgetPage,
  ['budget.permissions.show?', 'isLoading'],
  (props, rs) => ROUTES.group.plan.budget.index.path(rs.params('group_id')),
  'You don\'t have permission to view this budget requests'
));
