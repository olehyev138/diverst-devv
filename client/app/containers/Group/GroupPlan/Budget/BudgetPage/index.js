import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams, useLocation } from 'react-router-dom';

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

import { ROUTES } from 'containers/Shared/Routes/constants';
import Budget from 'components/Group/GroupPlan/Budget';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function BudgetPage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });
  useInjectReducer({ key: 'budgetItems', reducer: itemReducer });
  useInjectSaga({ key: 'budgetItems', saga: itemSaga });

  const groupId = props?.budget?.group_id;
  const annualBudgetId = props?.budget?.annual_budget_id;

  const links = {
    back: ROUTES.group.plan.budget.budgets.index.path(groupId, annualBudgetId)
  };

  const { budget_id: budgetId } = useParams();
  const location = useLocation();

  const budget = props?.budget || location.budget;

  useEffect(() => {
    if (!budget || budget.id !== budgetId)
      props.getBudgetBegin({ id: budgetId });
    else
      props.getBudgetSuccess({ budget });

    return () => props.budgetsUnmount();
  }, []);

  useEffect(() => {
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
  (props, params) => ROUTES.group.plan.budget.index.path(params.group_id),
  permissionMessages.group.groupPlan.budget.showPage
));
