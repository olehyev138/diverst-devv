import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';
import produce from 'immer/dist/immer';

const selectExpenseDomain = state => state.expenses || initialState;

const selectPaginatedExpenses = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.expenseList
);

const selectExpensesTotal = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.expenseListTotal
);

const selectExpenseListSum = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.expenseListSum
);

const selectExpense = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.currentExpense
);

const selectFormExpense = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.currentExpense && produce(expenseState.currentExpense, (draft) => {
    draft.budget_item = {
      label: expenseState.currentExpense.budget_user.budget_item.title,
      value: expenseState.currentExpense.budget_user.budget_item.id,
    };
  })
);

const selectIsFetchingExpenses = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.isFetchingExpenses
);

const selectIsFetchingExpense = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.isFetchingExpense
);

const selectIsCommitting = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.hasChanged
);

export {
  selectExpenseDomain,
  selectPaginatedExpenses,
  selectExpensesTotal,
  selectExpenseListSum,
  selectExpense,
  selectFormExpense,
  selectIsFetchingExpenses,
  selectIsFetchingExpense,
  selectIsCommitting,
  selectHasChanged,
};
