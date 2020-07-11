/*
 *
 * Session reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_SESSION_BEGIN,
  GET_SESSION_SUCCESS,
  GET_SESSION_ERROR,
  GET_HOSTING_SESSIONS_BEGIN,
  GET_HOSTING_SESSIONS_SUCCESS,
  GET_HOSTING_SESSIONS_ERROR,
  GET_PARTICIPATING_SESSIONS_BEGIN,
  GET_PARTICIPATING_SESSIONS_SUCCESS,
  GET_PARTICIPATING_SESSIONS_ERROR,
  GET_PARTICIPATING_USERS_BEGIN,
  GET_PARTICIPATING_USERS_SUCCESS,
  GET_PARTICIPATING_USERS_ERROR,
  CREATE_SESSION_BEGIN,
  CREATE_SESSION_SUCCESS,
  CREATE_SESSION_ERROR,
  UPDATE_SESSION_BEGIN,
  UPDATE_SESSION_SUCCESS,
  UPDATE_SESSION_ERROR,
  DELETE_SESSION_BEGIN,
  DELETE_SESSION_SUCCESS,
  DELETE_SESSION_ERROR,
  ACCEPT_INVITATION_BEGIN,
  ACCEPT_INVITATION_SUCCESS,
  ACCEPT_INVITATION_ERROR,
  DECLINE_INVITATION_BEGIN,
  DECLINE_INVITATION_SUCCESS,
  DECLINE_INVITATION_ERROR,
  SESSIONS_UNMOUNT,
  SESSION_USERS_UNMOUNT,
} from './constants';

export const initialState = {
  sessionList: [],
  userList: [],
  sessionListTotal: null,
  currentSession: null,
  isFetchingSessions: true,
  isFetchingSession: true,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function sessionReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_SESSION_BEGIN:
        draft.isFetchingSession = true;
        break;

      case GET_SESSION_SUCCESS:
        draft.currentSession = action.payload.mentoring_session;
        draft.isFetchingSession = false;
        break;

      case GET_SESSION_ERROR:
        draft.isFetchingSession = false;
        break;

      case GET_HOSTING_SESSIONS_BEGIN:
      case GET_PARTICIPATING_SESSIONS_BEGIN:
      case GET_PARTICIPATING_USERS_BEGIN:
        draft.isFetchingSessions = true;
        draft.hasChanged = false;
        break;

      case GET_HOSTING_SESSIONS_SUCCESS:
        draft.sessionList = action.payload.items;
        draft.sessionListTotal = action.payload.total;
        draft.isFetchingSessions = false;
        break;

      case GET_PARTICIPATING_SESSIONS_SUCCESS:
        draft.sessionList = formatSessions(action.payload.items);
        draft.sessionListTotal = action.payload.total;
        draft.isFetchingSessions = false;
        break;

      case GET_PARTICIPATING_USERS_SUCCESS:
        draft.userList = formatUsers(action.payload.items);
        draft.sessionListTotal = action.payload.total;
        draft.isFetchingSessions = false;
        break;

      case GET_HOSTING_SESSIONS_ERROR:
      case GET_PARTICIPATING_SESSIONS_ERROR:
      case GET_PARTICIPATING_USERS_ERROR:
        draft.isFetchingSessions = false;
        break;

      case CREATE_SESSION_BEGIN:
      case UPDATE_SESSION_BEGIN:
      case DELETE_SESSION_BEGIN:
      case ACCEPT_INVITATION_BEGIN:
      case DECLINE_INVITATION_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_SESSION_SUCCESS:
      case UPDATE_SESSION_SUCCESS:
      case DELETE_SESSION_SUCCESS:
      case ACCEPT_INVITATION_SUCCESS:
      case DECLINE_INVITATION_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_SESSION_ERROR:
      case UPDATE_SESSION_ERROR:
      case DELETE_SESSION_ERROR:
      case ACCEPT_INVITATION_ERROR:
      case DECLINE_INVITATION_ERROR:
        draft.isCommitting = false;
        draft.hasChanged = false;
        break;

      case SESSIONS_UNMOUNT:
        return initialState;

      case SESSION_USERS_UNMOUNT:
        draft.userList = [];
        draft.sessionListTotal = null;
        draft.hasChanged = false;
        draft.isFetchingSessions = true;
        break;
    }
  });
}
export default sessionReducer;

function formatSessions(joinedData) {
  return joinedData.map(x => x.mentoring_session);
}

function formatUsers(joinedData) {
  return joinedData.map(x => ({ user: x.user, status: x.status, role: x.role }));
}
