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
import { ROUTES } from 'containers/Shared/Routes/constants';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';

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
import {
  finalizeExpensesBegin
} from 'containers/Event/actions';

import reducer from '../reducer';
import saga from '../saga';

import BudgetList from 'components/Event/EventManage/BudgetList';
import { selectEvent } from 'containers/Event/selectors';
import { selectGroup } from 'containers/Group/selectors';
import { selectCustomText } from 'containers/Shared/App/selectors';

const handleVisitEditPage = (groupId, eventId, id) => push(ROUTES.group.plan.events.manage.expenses.edit.path(groupId, eventId, id));

export function ExpenseListPage(props) {
  useInjectReducer({ key: 'expenses', reducer });
  useInjectSaga({ key: 'expenses', saga });

  const links = {
    newExpense: ROUTES.group.plan.events.manage.expenses.new.path(props.currentGroup.id, props.currentEvent.id),
    editExpense: id => props.handleVisitEditPage(props.currentGroup.id, props.currentEvent.id, id),
    initiativeManage: ROUTES.group.plan.events.index.path(props.currentGroup.id, props.currentEvent.id),
  };

  return (
    <React.Fragment>
      <BudgetList
        initiative={props.currentEvent}
        currentGroup={props.currentGroup}
        handleVisitEditPage={props.handleVisitEditPage}
        deleteExpenseBegin={props.deleteExpenseBegin}
        finalizeExpensesBegin={props.finalizeExpensesBegin}
        links={links}
        customTexts={props.customTexts}
        isCommitting={props.isCommitting}
      />
    </React.Fragment>
  );
}

ExpenseListPage.propTypes = {
  createExpenseBegin: PropTypes.func.isRequired,
  updateExpenseBegin: PropTypes.func.isRequired,
  handleVisitEditPage: PropTypes.func.isRequired,
  finalizeExpensesBegin: PropTypes.func.isRequired,
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
  }),
  customTexts: PropTypes.object,
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
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  createExpenseBegin,
  updateExpenseBegin,
  deleteExpenseBegin,
  handleVisitEditPage,
  expensesUnmount,
  finalizeExpensesBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ExpenseListPage);
