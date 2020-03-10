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
import {
  selectPaginatedBudgets,
  selectBudgetsTotal,
  selectIsFetchingBudgets,
  selectHasChanged
} from 'containers/Group/GroupPlan/Budget/selectors';
import { selectAnnualBudget } from 'containers/Group/GroupPlan/AnnualBudget/selectors';

import saga from 'containers/Group/GroupPlan/Budget/saga';
import reducer from 'containers/Group/GroupPlan/Budget/reducer';
import annualSaga from 'containers/Group/GroupPlan/AnnualBudget/saga';
import annualReducer from 'containers/Group/GroupPlan/AnnualBudget/reducer';

import { getBudgetsBegin, budgetsUnmount, deleteBudgetBegin } from 'containers/Group/GroupPlan/Budget/actions';
import { getAnnualBudgetBegin, getAnnualBudgetSuccess } from 'containers/Group/GroupPlan/AnnualBudget/actions';
import { Button } from '@material-ui/core';
import RouteService from 'utils/routeHelpers';

import BudgetList from 'components/Group/GroupPlan/BudgetList';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectGroup } from 'containers/Group/selectors';
import { push } from 'connected-react-router';

export function BudgetsPage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });
  useInjectReducer({ key: 'annualBudgets', reducer: annualReducer });
  useInjectSaga({ key: 'annualBudgets', saga: annualSaga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const annualId = rs.params('annual_budget_id');

  const { location } = rs;
  const annualBudget = props.currentAnnualBudget || location.update;

  const getBudget = (params) => {
    props.getBudgetsBegin({
      ...params,
      annual_budget_id: annualId,
    });
  };

  const links = {
    annualBudgetOverview: ROUTES.group.plan.budget.overview.path(groupId),
    newRequest: ROUTES.group.plan.budget.budgets.new.path(groupId, annualId),
    requestDetails: id => ROUTES.group.plan.budget.budgets.index.path(groupId, annualId, id)
  };

  useEffect(() => {
    // eslint-disable-next-line eqeqeq
    if (!annualBudget || annualBudget.id != annualId)
      props.getAnnualBudgetBegin({ id: annualId });
    else
      props.getAnnualBudgetSuccess({ annual_budget: annualBudget });
    getBudget(params);

    return () => props.budgetsUnmount();
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      getBudget(params);
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getBudget(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getBudget(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <BudgetList
        budgets={props.budgets || {}}
        budgetTotal={props.budgetTotal}
        isFetchingBudgets={props.isLoading}
        deleteBudgetBegin={props.deleteBudgetBegin}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        annualBudget={props.currentAnnualBudget}
        currentGroup={props.currentGroup}
        handleVisitBudgetShow={props.handleVisitBudgetShow}
        links={links}
      />
    </React.Fragment>
  );
}

BudgetsPage.propTypes = {
  getBudgetsBegin: PropTypes.func.isRequired,
  budgetsUnmount: PropTypes.func.isRequired,
  getAnnualBudgetBegin: PropTypes.func.isRequired,
  getAnnualBudgetSuccess: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  hasChanged: PropTypes.bool,
  currentAnnualBudget: PropTypes.object,
  currentGroup: PropTypes.object,
  budgets: PropTypes.array,
  budgetTotal: PropTypes.number,
  deleteBudgetBegin: PropTypes.func,
  handleVisitBudgetShow: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectIsFetchingBudgets(),
  hasChanged: selectHasChanged(),
  budgets: selectPaginatedBudgets(),
  budgetTotal: selectBudgetsTotal(),
  currentAnnualBudget: selectAnnualBudget(),
  currentGroup: selectGroup(),
});

const mapPushDispatchToProps = dispatch => ({
  handleVisitBudgetShow: (groupId, annualId, id) => dispatch(push(ROUTES.group.plan.budget.budgets.show.path(groupId, annualId, id))),
  getBudgetsBegin: payload => dispatch(getBudgetsBegin(payload)),
  budgetsUnmount: () => dispatch(budgetsUnmount()),
  deleteBudgetBegin: payload => dispatch(deleteBudgetBegin(payload)),
  getAnnualBudgetBegin: payload => dispatch(getAnnualBudgetBegin(payload)),
  getAnnualBudgetSuccess: payload => dispatch(getAnnualBudgetSuccess(payload)),
});

const withConnect = connect(
  mapStateToProps,
  mapPushDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(BudgetsPage);
