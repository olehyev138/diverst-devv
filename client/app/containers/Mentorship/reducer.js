/*
 *
 * User reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_MENTORSHIP_USERS_BEGIN,
  GET_MENTORSHIP_USERS_SUCCESS,
  GET_MENTORSHIP_USERS_ERROR,
  GET_MENTORSHIP_USER_SUCCESS,
  MENTORSHIP_USER_UNMOUNT,
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
} from 'containers/Mentorship/constants';

export const initialState = {
  userList: {},
  userTotal: null,

  mentorList: [],
  mentorTotal: null,

  availableMentorList: [],
  availableMentorTotal: null,

  menteeList: [],
  menteeTotal: null,

  availableMenteeList: [],
  availableMenteeTotal: null,

  mentorRequestList: [],
  mentorRequestTotal: null,

  menteeRequestList: [],
  menteeRequestTotal: null,

  currentUser: null,

  isFetchingUsers: false,
  isFetchingMentors: false,
  isFetchingMentees: false,
  isFetchingAvailableMentors: false,
  isFetchingAvailableMentees: false,
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
      case GET_USER_MENTORS_BEGIN:
        draft.isFetchingMentors = true;
        break;
      case GET_USER_MENTEES_BEGIN:
        draft.isFetchingMentees = true;
        break;
      case GET_AVAILABLE_MENTORS_BEGIN:
        draft.isFetchingAvailableMentors = true;
        break;
      case GET_AVAILABLE_MENTEES_BEGIN:
        draft.isFetchingAvailableMentees = true;
        break;

      // ERROR
      case GET_MENTORSHIP_USERS_ERROR:
        draft.isFetchingUsers = false;
        return;
      case GET_USER_MENTORS_ERROR:
        draft.isFetchingMentors = false;
        break;
      case GET_USER_MENTEES_ERROR:
        draft.isFetchingMentees = false;
        break;
      case GET_AVAILABLE_MENTORS_ERROR:
        draft.isFetchingAvailableMentors = false;
        break;
      case GET_AVAILABLE_MENTEES_ERROR:
        draft.isFetchingAvailableMentees = false;
        break;

      // SUCCESS
      case GET_MENTORSHIP_USER_SUCCESS:
        draft.currentUser = action.payload.user;
        break;
      case GET_MENTORSHIP_USERS_SUCCESS:
        draft.userList = formatUsers(action.payload.items);
        draft.userTotal = action.payload.total;
        draft.isFetchingUsers = false;
        break;
      case GET_USER_MENTORS_SUCCESS:
        draft.mentorList = action.payload.items;
        draft.mentorTotal = action.payload.total;
        draft.isFetchingMentors = false;
        break;
      case GET_USER_MENTEES_SUCCESS:
        draft.menteeList = action.payload.items;
        draft.menteeTotal = action.payload.total;
        draft.isFetchingMentees = false;
        break;
      case GET_AVAILABLE_MENTORS_SUCCESS:
        draft.availableMentorList = action.payload.items;
        draft.availableMentorTotal = action.payload.total;
        draft.isFetchingAvailableMentors = false;
        break;
      case GET_AVAILABLE_MENTEES_SUCCESS:
        draft.availableMenteeList = action.payload.items;
        draft.availableMenteeTotal = action.payload.total;
        draft.isFetchingAvailableMentees = false;
        break;

      // UNMOUNT
      case MENTORSHIP_USER_UNMOUNT:
        return initialState;
      case MENTORSHIP_MENTORS_UNMOUNT:
        draft.mentorList = [];
        draft.mentorTotal = null;
        draft.menteeList = [];
        draft.menteeTotal = null;
        draft.availableMentorList = [];
        draft.availableMentorTotal = null;
        draft.availableMenteeList = [];
        draft.availableMenteeTotal = null;
        draft.isFetchingMentors = false;
        draft.isFetchingMentees = false;
        draft.isFetchingAvailableMentors = false;
        draft.isFetchingAvailableMentees = false;
        draft.currentUser = null;
        break;
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
