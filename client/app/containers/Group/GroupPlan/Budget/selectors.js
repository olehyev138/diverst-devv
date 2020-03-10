import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectBudgetDomain = state => state.budgets || initialState;

const selectPaginatedBudgets = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.budgetList
);

const selectBudgetsTotal = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.budgetListTotal
);

const selectBudget = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.currentBudget
);

const selectIsFetchingBudgets = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.isFetchingBudgets
);

const selectIsFetchingBudget = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.isFetchingBudget
);

const selectIsCommitting = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectBudgetDomain,
  budgetState => budgetState.hasChanged
);

export {
  selectBudgetDomain,
  selectPaginatedBudgets,
  selectBudgetsTotal,
  selectBudget,
  selectIsFetchingBudgets,
  selectIsFetchingBudget,
  selectIsCommitting,
  selectHasChanged,
};
