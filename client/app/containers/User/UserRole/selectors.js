import { createSelector } from 'reselect/lib';
import produce from 'immer';

import { initialState } from 'containers/User/UserRole/reducer';

const selectUserRoleDomain = state => state.roles || initialState;

const selectPaginatedUserRoles = () => createSelector(
  selectUserRoleDomain,
  roleState => roleState.userRoleList
);

const selectPaginatedSelectUserRoles = () => createSelector(
  selectUserRoleDomain,
  roleState => (
    Object
      .values(roleState.userRoleList)
      .map(role => ({ label: role.role_name, value: role.id }))
  )
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

const selectFormUserRole = () => createSelector(
  selectUserRoleDomain,
  (roleState) => {
    if (!roleState.currentUserRole)
      return null;

    return produce(roleState.currentUserRole, (draft) => {
      draft.role_type = {
        label: draft.role_type.charAt(0).toUpperCase() + draft.role_type.slice(1),
        value: draft.role_type
      };
    });
  }
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
  selectIsCommitting, selectIsFormLoading, selectFormUserRole,
  selectPaginatedSelectUserRoles,
};
