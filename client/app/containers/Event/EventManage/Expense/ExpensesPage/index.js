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

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
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
  selectHasChanged,
} from '../selectors';
import {
  getExpensesBegin, createExpenseBegin, updateExpenseBegin,
  expensesUnmount, deleteExpenseBegin
} from '../actions';

import reducer from '../reducer';
import saga from '../saga';

// import ExpenseList from 'components/Shared/Expenses/ExpenseList';
import { selectEvent } from 'containers/Event/selectors';
import { selectGroup } from 'containers/Group/selectors';

export function ExpenseListPage(props) {
  useInjectReducer({ key: 'expenses', reducer });
  useInjectSaga({ key: 'expenses', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      order: 'asc',
      orderBy: 'expenses.id',
      expenseDefinerId: dig(props, 'currentEvent', 'id')
    }
  );

  useEffect(() => {
    props.getExpensesBegin(params);

    return () => {
      props.expenseUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      props.getExpensesBegin(params);

    return () => {
      props.expenseUnmount();
    };
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getExpensesBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      { props.expenses.map(ex => (
        <React.Fragment key={ex.id}>
          {ex.id}
          {ex.amount}
        </React.Fragment>
      ))}
    </React.Fragment>
  );
}

ExpenseListPage.propTypes = {
  getExpensesBegin: PropTypes.func.isRequired,
  createExpenseBegin: PropTypes.func.isRequired,
  updateExpenseBegin: PropTypes.func.isRequired,
  expenses: PropTypes.object,
  expenseTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  deleteExpenseBegin: PropTypes.func,
  expenseUnmount: PropTypes.func.isRequired,
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
