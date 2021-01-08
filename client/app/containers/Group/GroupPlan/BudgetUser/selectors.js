import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectBudgetUserDomain = state => state.budgetUsers || initialState;

const selectPaginatedBudgetUsers = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.budgetUserList
);

const selectBudgetUsersTotal = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.budgetUserListTotal
);

const selectBudgetUser = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.currentBudgetUser
);

const selectIsFetchingBudgetUsers = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.isFetchingBudgetUsers
);

const selectIsFetchingBudgetUser = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.isFetchingBudgetUser
);

const selectIsCommitting = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectBudgetUserDomain,
  budgetUserState => budgetUserState.hasChanged
);

export {
  selectBudgetUserDomain,
  selectPaginatedBudgetUsers,
  selectBudgetUsersTotal,
  selectBudgetUser,
  selectIsFetchingBudgetUsers,
  selectIsFetchingBudgetUser,
  selectIsCommitting,
  selectHasChanged,
};
