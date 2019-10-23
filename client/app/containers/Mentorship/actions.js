/*
 *
 * Mentorship actions
 *
 */

import {
  GET_MENTORSHIP_USERS_BEGIN,
  GET_MENTORSHIP_USERS_SUCCESS,
  GET_MENTORSHIP_USERS_ERROR,
  GET_MENTORSHIP_USER_BEGIN,
  GET_MENTORSHIP_USER_SUCCESS,
  GET_MENTORSHIP_USER_ERROR,
  UPDATE_MENTORSHIP_USER_BEGIN,
  UPDATE_MENTORSHIP_USER_SUCCESS,
  UPDATE_MENTORSHIP_USER_ERROR,
  MENTORSHIP_USER_UNMOUNT,
} from 'containers/Mentorship/constants';

/* User listing */

export function getUsersBegin(payload) {
  return {
    type: GET_MENTORSHIP_USERS_BEGIN,
    payload
  };
}

export function getUsersSuccess(payload) {
  return {
    type: GET_MENTORSHIP_USERS_SUCCESS,
    payload
  };
}

export function getUsersError(error) {
  return {
    type: GET_MENTORSHIP_USERS_ERROR,
    error,
  };
}

/* Getting specific user */

export function getUserBegin(payload) {
  return {
    type: GET_MENTORSHIP_USER_BEGIN,
    payload,
  };
}

export function getUserSuccess(payload) {
  return {
    type: GET_MENTORSHIP_USER_SUCCESS,
    payload,
  };
}

export function getUserError(error) {
  return {
    type: GET_MENTORSHIP_USER_ERROR,
    error,
  };
}


/* User updating */

export function updateUserBegin(payload) {
  return {
    type: UPDATE_MENTORSHIP_USER_BEGIN,
    payload,
  };
}

export function updateUserSuccess(payload) {
  return {
    type: UPDATE_MENTORSHIP_USER_SUCCESS,
    payload,
  };
}

export function updateUserError(error) {
  return {
    type: UPDATE_MENTORSHIP_USER_ERROR,
    error,
  };
}

export function userUnmount() {
  return {
    type: MENTORSHIP_USER_UNMOUNT
  };
}
