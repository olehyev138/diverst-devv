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

import { getBudgetBegin, budgetsUnmount, approveBudgetBegin, declineBudgetBegin } from 'containers/Group/GroupPlan/Budget/actions';
import { selectGroup } from 'containers/Group/selectors';
import { selectIsFetchingBudget, selectBudget, selectIsCommitting } from 'containers/Group/GroupPlan/Budget/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Budget from 'components/Group/GroupPlan/Budget';

export function BudgetCreatePage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });

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
      props.getBudgetBegin({ budget });

    return () => props.budgetsUnmount();
  }, []);

  return (
    <Budget
      budget={props.budget}
      approveAction={props.approveBudgetBegin}
      declineAction={props.declineBudgetBegin}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

BudgetCreatePage.propTypes = {
  getBudgetBegin: PropTypes.func,
  budgetsUnmount: PropTypes.func,
  approveBudgetBegin: PropTypes.func,
  declineBudgetBegin: PropTypes.func,

  currentGroup: PropTypes.object,
  budget: PropTypes.object,

  isLoading: PropTypes.bool,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectIsFetchingBudget(),
  isCommitting: selectIsCommitting(),
  budget: selectBudget(),
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
  getBudgetBegin,
  budgetsUnmount,
  approveBudgetBegin,
  declineBudgetBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(BudgetCreatePage);
