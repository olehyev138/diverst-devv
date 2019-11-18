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
  GET_LEADING_SESSIONS_BEGIN,
  GET_LEADING_SESSIONS_SUCCESS,
  GET_LEADING_SESSIONS_ERROR,
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
  SESSION_UNMOUNT,
} from './constants';

export const initialState = {
  sessionList: [],
  sessionListTotal: null,
  currentSession: null,
  isFetchingSessions: false,
  isCommitting: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function sessionReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_LEADING_SESSIONS_BEGIN:
      case GET_PARTICIPATING_SESSIONS_BEGIN:
        draft.isFetchingSessions = true;
        break;

      case GET_LEADING_SESSIONS_ERROR:
      case GET_PARTICIPATING_SESSIONS_ERROR:
        draft.isFetchingSessions = false;
        break;

      case GET_SESSION_SUCCESS:
        draft.currentSession = action.payload.session;
        break;

      case GET_LEADING_SESSIONS_SUCCESS:
      case GET_PARTICIPATING_SESSIONS_SUCCESS:
        draft.sessionList = action.payload.items;
        draft.sessionListTotal = action.payload.total;
        draft.isFetchingSessions = false;
        break;

      case CREATE_SESSION_BEGIN:
      case UPDATE_SESSION_BEGIN:
      case DELETE_SESSION_BEGIN:
        draft.isCommitting = true;
        break;

      case CREATE_SESSION_SUCCESS:
      case CREATE_SESSION_ERROR:
      case UPDATE_SESSION_SUCCESS:
      case UPDATE_SESSION_ERROR:
      case DELETE_SESSION_SUCCESS:
      case DELETE_SESSION_ERROR:
        draft.isCommitting = false;
        break;

      case SESSION_UNMOUNT:
        return initialState;
    }
  });
}
export default sessionReducer;
