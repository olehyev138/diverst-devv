/*
 *
 * User reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_USER_ROLES_BEGIN, GET_USER_ROLES_SUCCESS,
  GET_USER_ROLES_ERROR, GET_USER_ROLE_SUCCESS, USER_ROLE_UNMOUNT,
  CREATE_USER_ROLE_BEGIN, CREATE_USER_ROLE_SUCCESS, CREATE_USER_ROLE_ERROR,
  UPDATE_USER_ROLE_BEGIN, UPDATE_USER_ROLE_SUCCESS, UPDATE_USER_ROLE_ERROR,
  GET_USER_ROLE_BEGIN, GET_USER_ROLE_ERROR,
} from 'containers/User/UserRole/constants';

export const initialState = {
  isFormLoading: true,
  isCommitting: false,
  userRoleList: {},
  userRoleTotal: null,
  currentUserRole: null,
  isFetchingUserRoles: true,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function usersReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_USER_ROLES_BEGIN:
        draft.isFetchingUserRoles = true;
        return;
      case GET_USER_ROLES_SUCCESS:
        draft.userRoleList = formatUserRoles(action.payload.items);
        draft.userRoleTotal = action.payload.total;
        draft.isFetchingUserRoles = false;
        break;
      case GET_USER_ROLES_ERROR:
        draft.isFetchingUserRoles = false;
        return;
      case GET_USER_ROLE_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_USER_ROLE_SUCCESS:
        draft.currentUserRole = action.payload.user_role;
        draft.isFormLoading = false;
        break;
      case GET_USER_ROLE_ERROR:
        draft.isFormLoading = false;
        break;
      case CREATE_USER_ROLE_BEGIN:
      case UPDATE_USER_ROLE_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_USER_ROLE_SUCCESS:
      case UPDATE_USER_ROLE_SUCCESS:
      case CREATE_USER_ROLE_ERROR:
      case UPDATE_USER_ROLE_ERROR:
        draft.isCommitting = false;
        break;
      case USER_ROLE_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

/*
 * Format users to hash by id
 */
function formatUserRoles(roles) {
  return roles.reduce((map, role) => {
    map[role.id] = role;
    return map;
  }, {});
}


export default usersReducer;
