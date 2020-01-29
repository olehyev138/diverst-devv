import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectBudgetItemDomain = state => state.budgetItems || initialState;

const selectPaginatedBudgetItems = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.budgetItemList
);

const selectBudgetItemsTotal = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.budgetItemListTotal
);

const selectBudgetItem = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.currentBudgetItem
);

const selectIsFetchingBudgetItems = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.isFetchingBudgetItems
);

const selectIsFetchingBudgetItem = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.isFetchingBudgetItem
);

const selectIsCommitting = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.hasChanged
);

export {
  selectBudgetItemDomain,
  selectPaginatedBudgetItems,
  selectBudgetItemsTotal,
  selectBudgetItem,
  selectIsFetchingBudgetItems,
  selectIsFetchingBudgetItem,
  selectIsCommitting,
  selectHasChanged,
};
