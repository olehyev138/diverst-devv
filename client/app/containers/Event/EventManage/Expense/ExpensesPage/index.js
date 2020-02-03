/**
 *
 * ExpensesPage
 *
 *  - lists all enterprise custom expenses
 *  - renders forms for creating & editing custom expenses
 *
 *  - function:
 *    - get expenses from server
 *    - on edit - render respective form with expense data
 *    - on new - render respective empty form
 *    - on save - create/update expense
 */

import React, { memo, useContext, useEffect, useState } from 'react';
import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';
import dig from 'object-dig';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedExpenses,
  selectExpensesTotal,
  selectIsFetchingExpenses,
  selectIsCommitting,
  selectHasChanged, selectExpenseListSum,
} from '../selectors';
import {
  getExpensesBegin, createExpenseBegin, updateExpenseBegin,
  expensesUnmount, deleteExpenseBegin
} from '../actions';

import reducer from '../reducer';
import saga from '../saga';

import ExpenseList from 'components/Event/EventManage/ExpensesList';
import { selectEvent } from 'containers/Event/selectors';
import { selectGroup } from 'containers/Group/selectors';

const handleVisitEditPage = (groupId, eventId, id) => push(ROUTES.group.plan.events.manage.expenses.edit.path(groupId, eventId, id));

export function ExpenseListPage(props) {
  useInjectReducer({ key: 'expenses', reducer });
  useInjectSaga({ key: 'expenses', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      order: 'asc',
      orderBy: 'initiative_expenses.id',
    }
  );

  const rs = new RouteService(useContext);
  const links = {
    newExpense: ROUTES.group.plan.events.manage.expenses.new.path(props.currentGroup.id, props.currentEvent.id),
    editExpense: id => props.handleVisitEditPage(props.currentGroup.id, props.currentEvent.id, id),
    initiativeManage: ROUTES.group.plan.events.index.path(props.currentGroup.id, props.currentEvent.id),
  };

  function getExpenses(params) {
    props.getExpensesBegin({
      ...params,
      initiative_id: props.currentEvent.id,
      sum: 'amount'
    });
  }

  useEffect(() => {
    getExpenses(params);

    return () => {
      props.expensesUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      getExpenses(params);

    return () => {
      props.expensesUnmount();
    };
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getExpenses(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getExpenses(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <ExpenseList
        initiative={props.currentEvent}
        currentGroup={props.currentGroup}
        expenses={props.expenses}
        expenseTotal={props.expenseTotal}
        expenseSumTotal={props.expenseSumTotal}
        isFetchingExpenses={props.isLoading}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        handleVisitEditPage={props.handleVisitEditPage}
        deleteExpenseBegin={props.deleteExpenseBegin}
        links={links}
      />
    </React.Fragment>
  );
}

ExpenseListPage.propTypes = {
  getExpensesBegin: PropTypes.func.isRequired,
  createExpenseBegin: PropTypes.func.isRequired,
  updateExpenseBegin: PropTypes.func.isRequired,
  handleVisitEditPage: PropTypes.func.isRequired,
  expenses: PropTypes.array,
  expenseTotal: PropTypes.number,
  expenseSumTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  deleteExpenseBegin: PropTypes.func,
  expensesUnmount: PropTypes.func.isRequired,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  hasChanged: PropTypes.bool,
  currentEvent: PropTypes.shape({
    id: PropTypes.number
  }),
  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  expenses: selectPaginatedExpenses(),
  expenseTotal: selectExpensesTotal(),
  expenseSumTotal: selectExpenseListSum(),
  isLoading: selectIsFetchingExpenses(),
  isCommitting: selectIsCommitting(),
  currentEvent: selectEvent(),
  currentGroup: selectGroup(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getExpensesBegin,
  createExpenseBegin,
  updateExpenseBegin,
  deleteExpenseBegin,
  handleVisitEditPage,
  expensesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ExpenseListPage);
