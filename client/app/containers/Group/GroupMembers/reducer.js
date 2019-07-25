/*
 *
 * User reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_USERS_SUCCESS,  USER_LIST_UNMOUNT
} from 'containers/Group/GroupMembers/constants';

export const initialState = {
  userList: {},
  userTotal: null,
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function usersReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_USERS_SUCCESS:
        draft.userList = formatUsers(action.payload.items);
        draft.userTotal = action.payload.total;
        break;
      case USER_LIST_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatUsers(users) {
  /* eslint-disable no-return-assign */

  /* Format users to hash by id:
   *   { <id>: { name: user_01, ... } }
   */
  return users.reduce((map, userGroup) => {
    map[userGroup.id] = userGroup.user;
    return map;
  }, {});
}

export default usersReducer;
