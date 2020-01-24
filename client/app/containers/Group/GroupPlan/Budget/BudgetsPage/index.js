/**
 *
 * BudgetsPage
 *
 */

import React, { memo, useContext, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedBudgets, selectBudgetsTotal, selectIsFetchingBudgets } from 'containers/Group/GroupPlan/Budget/selectors';

import saga from 'containers/Group/GroupPlan/Budget/saga';
import reducer from 'containers/Group/GroupPlan/Budget/reducer';

import { getBudgetsBegin, budgetsUnmount, deleteBudgetBegin } from 'containers/Group/GroupPlan/Budget/actions';
import { Button } from '@material-ui/core';
import RouteService from 'utils/routeHelpers';

// import BudgetList from 'components/Group/GroupPlan/Budget/GroupPlan/Budgets';

export function BudgetsPage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const rs = new RouteService(useContext);

  const getBudget = (params) => {
    const annualId = rs.params('annual_budget_id');
    const groupID = rs.params('group_id');
    props.getBudgetsBegin({
      ...params,
      annual_budget_id: annualId,
    });
  };

  useEffect(() => {
    getBudget(params);

    return () => props.budgetsUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getBudget(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      {props.budgets.map(bud => (
        <div key={bud.id}>
          {bud.requested_amount}
        </div>
      ))}
      <Button
        onClick={() => getBudget({})}
      >
        RELOAD
      </Button>
    </React.Fragment>
  );
}

BudgetsPage.propTypes = {
  getBudgetsBegin: PropTypes.func.isRequired,
  budgetsUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  budgets: PropTypes.array,
  budgetTotal: PropTypes.number,
  deleteBudgetBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectIsFetchingBudgets(),
  budgets: selectPaginatedBudgets(),
  budgetTotal: selectBudgetsTotal(),
});

const mapDispatchToProps = {
  getBudgetsBegin,
  budgetsUnmount,
  deleteBudgetBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(BudgetsPage);
