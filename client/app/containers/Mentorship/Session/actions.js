/*
 *
 * Session actions
 *
 */

import {
  GET_SESSION_BEGIN,
  GET_SESSION_SUCCESS,
  GET_SESSION_ERROR,
  GET_SESSIONS_BEGIN,
  GET_SESSIONS_SUCCESS,
  GET_SESSIONS_ERROR,
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

export function getSessionError(payload) {
  return {
    type: GET_SESSION_ERROR,
    payload,
  };
}

export function getSessionsBegin(payload) {
  return {
    type: GET_SESSIONS_BEGIN,
    payload,
  };
}

export function getSessionsSuccess(payload) {
  return {
    type: GET_SESSIONS_SUCCESS,
    payload,
  };
}

export function getSessionsError(payload) {
  return {
    type: GET_SESSIONS_ERROR,
    payload,
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

export function createSessionError(payload) {
  return {
    type: CREATE_SESSION_ERROR,
    payload,
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

export function updateSessionError(payload) {
  return {
    type: UPDATE_SESSION_ERROR,
    payload,
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

export function deleteSessionError(payload) {
  return {
    type: DELETE_SESSION_ERROR,
    payload,
  };
}

export function sessionUnmount(payload) {
  return {
    type: SESSION_UNMOUNT,
    payload,
  };
}
