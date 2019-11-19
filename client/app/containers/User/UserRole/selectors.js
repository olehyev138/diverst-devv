import { createSelector } from 'reselect/lib';

import produce from 'immer';
import dig from 'object-dig';

import { initialState } from 'containers/User/reducer';

const selectUserRoleDomain = state => state.users || initialState;

const selectPaginatedUserRole = () => createSelector(
  selectUserRoleDomain,
  usersState => usersState.userList
);

const selectUserTotal = () => createSelector(
  selectUserRoleDomain,
  usersState => usersState.userTotal
);

const selectIsFetchingUserRole = () => createSelector(
  selectUserRoleDomain,
  usersState => usersState.isFetchingUserRole
);

const selectUserRole = () => createSelector(
  selectUserRoleDomain,
  userState => userState.currentUserRole
);

const selectIsFormLoading = () => createSelector(
  selectUserRoleDomain,
  userState => userState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectUserRoleDomain,
  userState => userState.isCommitting
);

export {
  selectUserRoleDomain, selectPaginatedUserRole,
  selectUserTotal, selectUserRole, selectIsFetchingUserRole,
  selectIsCommitting, selectIsFormLoading
};
