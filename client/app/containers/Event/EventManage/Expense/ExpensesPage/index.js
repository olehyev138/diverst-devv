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
  selectExpenseListSum,
  selectHasChanged as selectExpenseHasChanged } from '../selectors';
import {
  getExpensesBegin, createExpenseBegin, updateExpenseBegin,
  expensesUnmount, deleteExpenseBegin
} from '../actions';
import { getBudgetUsersBegin, finalizeExpensesBegin } from 'containers/Group/GroupPlan/BudgetUser/actions';

import reducer from '../reducer';
import saga from '../saga';
import budgetUserReducer from 'containers/Group/GroupPlan/BudgetUser/reducer';
import budgetUserSaga from 'containers/Group/GroupPlan/BudgetUser/saga';

import BudgetList from 'components/Event/EventManage/BudgetList';
import { selectEvent } from 'containers/Event/selectors';
import { selectGroup } from 'containers/Group/selectors';

import { selectCustomText } from 'containers/Shared/App/selectors';
import {
  selectIsFetchingBudgetUsers,
  selectHasChanged,
  selectPaginatedBudgetUsers
} from 'containers/Group/GroupPlan/BudgetUser/selectors';

const handleVisitEditPage = (groupId, eventId, id) => push(ROUTES.group.plan.events.manage.expenses.edit.path(groupId, eventId, id));

export function ExpenseListPage(props) {
  useInjectReducer({ key: 'expenses', reducer });
  useInjectSaga({ key: 'expenses', saga });
  useInjectReducer({ key: 'budgetUsers', reducer: budgetUserReducer });
  useInjectSaga({ key: 'budgetUsers', saga: budgetUserSaga });

  const links = {
    newExpense: ROUTES.group.plan.events.manage.expenses.new.path(props.currentGroup.id, props.currentEvent.id),
    editExpense: id => props.handleVisitEditPage(props.currentGroup.id, props.currentEvent.id, id),
    initiativeManage: ROUTES.group.plan.events.index.path(props.currentGroup.id, props.currentEvent.id),
  };

  function getBudgetUsers() {
    props.getBudgetUsersBegin({
      count: -1,
      order: 'asc',
      initiative_id: props.currentEvent.id
    });
  }

  useEffect(() => {
    getBudgetUsers();
  }, [props.currentEvent]);

  useEffect(() => {
    if (props.hasChanged)
      getBudgetUsers();
  }, [props.currentEvent]);

  useEffect(() => {
    if (props.expensesHasChanged)
      getBudgetUsers();
  }, [props.expensesHasChanged]);

  return (
    <React.Fragment>
      <BudgetList
        budgetUsers={props.budgetUsers}
        isLoading={props.isLoading}
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
  getBudgetUsersBegin: PropTypes.func.isRequired,
  updateExpenseBegin: PropTypes.func.isRequired,
  handleVisitEditPage: PropTypes.func.isRequired,
  finalizeExpensesBegin: PropTypes.func.isRequired,
  deleteExpenseBegin: PropTypes.func,
  expensesUnmount: PropTypes.func.isRequired,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  hasChanged: PropTypes.bool,
  isLoading: PropTypes.bool,
  currentEvent: PropTypes.shape({
    id: PropTypes.number
  }),
  currentGroup: PropTypes.shape({
    id: PropTypes.number
  }),
  customTexts: PropTypes.object,
  budgetUsers: PropTypes.array,
  expensesHasChanged: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  budgetUsers: selectPaginatedBudgetUsers(),
  isLoading: selectIsFetchingBudgetUsers(),
  expenses: selectPaginatedExpenses(),
  expenseTotal: selectExpensesTotal(),
  expenseSumTotal: selectExpenseListSum(),
  isCommitting: selectIsCommitting(),
  currentEvent: selectEvent(),
  currentGroup: selectGroup(),
  hasChanged: selectHasChanged(),
  customTexts: selectCustomText(),
  expensesHasChanged: selectExpenseHasChanged(),
});

const mapDispatchToProps = {
  getBudgetUsersBegin,
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
