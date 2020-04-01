/*
 *
 * Mentoring reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_USER_MENTORS_BEGIN,
  GET_USER_MENTEES_BEGIN,
  GET_USER_MENTORS_ERROR,
  GET_USER_MENTEES_ERROR,
  GET_USER_MENTEES_SUCCESS,
  GET_USER_MENTORS_SUCCESS,
  MENTORSHIP_MENTORS_UNMOUNT,
  GET_AVAILABLE_MENTORS_ERROR,
  GET_AVAILABLE_MENTORS_BEGIN,
  GET_AVAILABLE_MENTORS_SUCCESS,
  GET_AVAILABLE_MENTEES_BEGIN,
  GET_AVAILABLE_MENTEES_ERROR,
  GET_AVAILABLE_MENTEES_SUCCESS,
} from 'containers/Mentorship/Mentoring/constants';

export const initialState = {
  userList: [],
  userTotal: null,
  currentUser: null,
  isFetchingUsers: true,

  mentorshipList: [],
  mentorshipListTotal: null,
  currentMentorship: null,
  isFetchingMentorships: true,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function mentorshipReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      // BEGIN
      case GET_USER_MENTORS_BEGIN:
      case GET_USER_MENTEES_BEGIN:
        draft.isFetchingMentorships = true;
        break;
      case GET_AVAILABLE_MENTORS_BEGIN:
      case GET_AVAILABLE_MENTEES_BEGIN:
        draft.isFetchingUsers = true;
        break;

      // ERROR
      case GET_USER_MENTORS_ERROR:
      case GET_USER_MENTEES_ERROR:
        draft.isFetchingMentorships = false;
        break;
      case GET_AVAILABLE_MENTORS_ERROR:
      case GET_AVAILABLE_MENTEES_ERROR:
        draft.isFetchingUsers = false;
        break;

      // SUCCESS
      case GET_USER_MENTORS_SUCCESS:
      case GET_USER_MENTEES_SUCCESS:
        draft.mentorshipList = action.payload.items;
        draft.mentorshipListTotal = action.payload.total;
        draft.isFetchingMentorships = false;
        break;
      case GET_AVAILABLE_MENTORS_SUCCESS:
      case GET_AVAILABLE_MENTEES_SUCCESS:
        draft.userList = action.payload.items;
        draft.userTotal = action.payload.total;
        draft.isFetchingUsers = false;
        break;

      // UNMOUNT
      case MENTORSHIP_MENTORS_UNMOUNT:
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
