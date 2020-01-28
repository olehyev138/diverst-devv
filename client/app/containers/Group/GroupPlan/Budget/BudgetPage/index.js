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

import { getBudgetBegin, budgetsUnmount } from 'containers/Group/GroupPlan/Budget/actions';
import { selectGroup } from 'containers/Group/selectors';
import { selectIsFetchingBudget, selectBudget } from 'containers/Group/GroupPlan/Budget/selectors';

import RouteService from 'utils/routeHelpers';

export function BudgetCreatePage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });


  const rs = new RouteService(useContext);
  const annualBudgetId = rs.params('annual_budget_id');
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
    <h1>
      {`Budget with id ${dig(props, 'budget', 'id')}`}
    </h1>
  );
}

BudgetCreatePage.propTypes = {
  getBudgetBegin: PropTypes.func,
  budgetsUnmount: PropTypes.func,

  currentGroup: PropTypes.object,
  budget: PropTypes.object,
  isLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectIsFetchingBudget(),
  budget: selectBudget(),
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
  getBudgetBegin,
  budgetsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(BudgetCreatePage);
