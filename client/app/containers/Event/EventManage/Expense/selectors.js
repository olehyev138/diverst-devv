import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectExpenseDomain = state => state.expenses || initialState;

const selectPaginatedExpenses = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.expenseList
);

const selectExpensesTotal = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.expenseListTotal
);

const selectExpense = () => createSelector(
  selectExpenseDomain,
  expenseState => expenseState.currentExpense
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
  selectExpense,
  selectIsFetchingExpenses,
  selectIsFetchingExpense,
  selectIsCommitting,
  selectHasChanged,
};
