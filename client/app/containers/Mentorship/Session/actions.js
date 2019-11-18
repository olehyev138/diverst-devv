/*
 *
 * Session actions
 *
 */

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
  SESSIONS_UNMOUNT,
} from './constants';

export function getSessionBegin(payload) {
  return {
    type: GET_SESSION_BEGIN,
    payload,
  };
}

export function getSessionSuccess(payload) {
  return {
    type: GET_SESSION_SUCCESS,
    payload,
  };
}

export function getSessionError(error) {
  return {
    type: GET_SESSION_ERROR,
    error,
  };
}

export function getLeadingSessionsBegin(payload) {
  return {
    type: GET_LEADING_SESSIONS_BEGIN,
    payload,
  };
}

export function getLeadingSessionsSuccess(payload) {
  return {
    type: GET_LEADING_SESSIONS_SUCCESS,
    payload,
  };
}

export function getLeadingSessionsError(error) {
  return {
    type: GET_LEADING_SESSIONS_ERROR,
    error,
  };
}

export function getParticipatingSessionsBegin(payload) {
  return {
    type: GET_PARTICIPATING_SESSIONS_BEGIN,
    payload,
  };
}

export function getParticipatingSessionsSuccess(payload) {
  return {
    type: GET_PARTICIPATING_SESSIONS_SUCCESS,
    payload,
  };
}

export function getParticipatingSessionsError(error) {
  return {
    type: GET_PARTICIPATING_SESSIONS_ERROR,
    error,
  };
}

export function createSessionBegin(payload) {
  return {
    type: CREATE_SESSION_BEGIN,
    payload,
  };
}

export function createSessionSuccess(payload) {
  return {
    type: CREATE_SESSION_SUCCESS,
    payload,
  };
}

export function createSessionError(error) {
  return {
    type: CREATE_SESSION_ERROR,
    error,
  };
}

export function updateSessionBegin(payload) {
  return {
    type: UPDATE_SESSION_BEGIN,
    payload,
  };
}

export function updateSessionSuccess(payload) {
  return {
    type: UPDATE_SESSION_SUCCESS,
    payload,
  };
}

export function updateSessionError(error) {
  return {
    type: UPDATE_SESSION_ERROR,
    error,
  };
}

export function deleteSessionBegin(payload) {
  return {
    type: DELETE_SESSION_BEGIN,
    payload,
  };
}

export function deleteSessionSuccess(payload) {
  return {
    type: DELETE_SESSION_SUCCESS,
    payload,
  };
}

export function deleteSessionError(error) {
  return {
    type: DELETE_SESSION_ERROR,
    error,
  };
}

export function sessionsUnmount(payload) {
  return {
    type: SESSIONS_UNMOUNT,
    payload,
  };
}
