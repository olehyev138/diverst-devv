/*
 *
 * User reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_USERS_SUCCESS, GET_USER_SUCCESS,
  USER_UNMOUNT
} from 'containers/User/constants';

export const initialState = {
  userList: {},
  userTotal: null,
  currentUser: null,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function usersReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_USERS_SUCCESS:
        draft.userList = formatUsers(action.payload.items);
        draft.userTotal = action.payload.total;
        break;
      case GET_USER_SUCCESS:
        draft.currentUser = deserializeFieldData(action.payload.user);
        break;
      case USER_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

/*
 * Format users to hash by id
 */
function formatUsers(users) {
  return users.reduce((map, user) => {
    map[user.id] = user;
    return map;
  }, {});
}

function deserializeFieldData(user) {
  user.field_data.forEach((fd) => {
    fd.data = JSON.parse(fd.data);
  });

  return user;
}

export default usersReducer;
