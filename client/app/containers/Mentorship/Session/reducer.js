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
  CREATE_SESSION_BEGIN,
  CREATE_SESSION_SUCCESS,
  CREATE_SESSION_ERROR,
  UPDATE_SESSION_BEGIN,
  UPDATE_SESSION_SUCCESS,
  UPDATE_SESSION_ERROR,
  DELETE_SESSION_BEGIN,
  DELETE_SESSION_SUCCESS,
  DELETE_SESSION_ERROR,
  SESSIONS_UNMOUNT,
} from './constants';

export const initialState = {
  sessionList: [],
  sessionListTotal: null,
  currentSession: null,
  isFetchingSessions: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function sessionReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_HOSTING_SESSIONS_BEGIN:
      case GET_PARTICIPATING_SESSIONS_BEGIN:
        draft.isFetchingSessions = true;
        draft.hasChanged = false;
        break;

      case GET_HOSTING_SESSIONS_ERROR:
      case GET_PARTICIPATING_SESSIONS_ERROR:
        draft.isFetchingSessions = false;
        draft.hasChanged = false;
        break;

      case GET_SESSION_SUCCESS:
        draft.currentSession = action.payload.mentoring_session;
        break;

      case GET_HOSTING_SESSIONS_SUCCESS:
        draft.sessionList = action.payload.items;
        draft.sessionListTotal = action.payload.total;
        draft.isFetchingSessions = false;
        draft.hasChanged = false;
        break;

      case GET_PARTICIPATING_SESSIONS_SUCCESS:
        draft.sessionList = formatSessions(action.payload.items);
        draft.sessionListTotal = action.payload.total;
        draft.isFetchingSessions = false;
        draft.hasChanged = false;
        break;

      case CREATE_SESSION_BEGIN:
      case UPDATE_SESSION_BEGIN:
      case DELETE_SESSION_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_SESSION_SUCCESS:
      case UPDATE_SESSION_SUCCESS:
      case DELETE_SESSION_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_SESSION_ERROR:
      case UPDATE_SESSION_ERROR:
      case DELETE_SESSION_ERROR:
        draft.isCommitting = false;
        draft.hasChanged = false;
        break;

      case SESSIONS_UNMOUNT:
        return initialState;
    }
  });
}
export default sessionReducer;

function formatSessions(joinedData) {
  return joinedData.map(x => x.mentoring_session);
}
