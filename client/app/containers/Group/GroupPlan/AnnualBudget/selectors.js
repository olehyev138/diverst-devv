import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectAnnualBudgetDomain = state => state.annualBudgets || initialState;

const selectPaginatedAnnualBudgets = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.annualBudgetList
);

const selectAnnualBudgetsTotal = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.annualBudgetListTotal
);

const selectPaginatedInitiatives = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.annualBudgetInitiativeList
);

const selectInitiativesTotal = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.annualBudgetInitiativeListTotal
);

const selectAnnualBudget = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.currentAnnualBudget
);

const selectIsFetchingAnnualBudgets = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.isFetchingAnnualBudgets
);

const selectIsFetchingAnnualBudget = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.isFetchingAnnualBudget
);

const selectIsCommitting = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectAnnualBudgetDomain,
  annualBudgetState => annualBudgetState.hasChanged
);

export {
  selectAnnualBudgetDomain,
  selectPaginatedAnnualBudgets,
  selectPaginatedInitiatives,
  selectInitiativesTotal,
  selectAnnualBudgetsTotal,
  selectAnnualBudget,
  selectIsFetchingAnnualBudgets,
  selectIsFetchingAnnualBudget,
  selectIsCommitting,
  selectHasChanged,
};
