import { createSelector } from 'reselect/lib';

import { initialState } from 'containers/User/UserRole/reducer';

const selectUserRoleDomain = state => state.roles || initialState;

const selectPaginatedUserRoles = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.userRoleList
);

const selectUserRoleTotal = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.userRoleTotal
);

const selectIsFetchingUserRoles = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.isFetchingUserRoles
);

const selectUserRole = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.currentUserRole
);

const selectIsFormLoading = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.isCommitting
);

export {
  selectUserRoleDomain, selectPaginatedUserRoles,
  selectUserRoleTotal, selectUserRole, selectIsFetchingUserRoles,
  selectIsCommitting, selectIsFormLoading
};
