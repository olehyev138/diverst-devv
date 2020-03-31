/*
 *
 * User reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_MENTORSHIP_USERS_BEGIN,
  GET_MENTORSHIP_USERS_ERROR,
  GET_MENTORSHIP_USER_SUCCESS,
  MENTORSHIP_USER_UNMOUNT,
} from 'containers/Mentorship/constants';

export const initialState = {
  userList: [],
  userTotal: null,

  currentUser: null,

  isFetchingUsers: true,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function mentorshipReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      // BEGIN
      case GET_MENTORSHIP_USERS_BEGIN:
        draft.isFetchingUsers = true;
        return;

      // ERROR
      case GET_MENTORSHIP_USERS_ERROR:
        draft.isFetchingUsers = false;
        return;

      // SUCCESS
      case GET_MENTORSHIP_USER_SUCCESS:
        draft.currentUser = action.payload.user;
        break;

      // UNMOUNT
      case MENTORSHIP_USER_UNMOUNT:
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


export default mentorshipReducer;
