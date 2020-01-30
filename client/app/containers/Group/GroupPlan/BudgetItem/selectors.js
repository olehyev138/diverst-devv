import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectBudgetItemDomain = state => state.budgetItems || initialState;

const selectPaginatedBudgetItems = () => createSelector(
  selectBudgetItemDomain,
  budgetItemState => budgetItemState.budgetItemList
);

const selectPaginatedSelectBudgetItems = () => createSelector(
  selectBudgetItemDomain,
  usersState => Object.values(usersState.budgetItemList).map(item => ({ label: item.title_with_amount, value: item.id }))
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
  selectPaginatedSelectBudgetItems,
  selectBudgetItemsTotal,
  selectBudgetItem,
  selectIsFetchingBudgetItems,
  selectIsFetchingBudgetItem,
  selectIsCommitting,
  selectHasChanged,
};
