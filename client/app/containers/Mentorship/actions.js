/*
 *
 * User actions
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
  GET_USER_MENTORS_BEGIN,
  GET_USER_MENTORS_SUCCESS,
  GET_USER_MENTORS_ERROR,
  GET_AVAILABLE_MENTORS_BEGIN,
  GET_AVAILABLE_MENTORS_SUCCESS,
  GET_AVAILABLE_MENTORS_ERROR,
  GET_USER_MENTEES_BEGIN,
  GET_USER_MENTEES_SUCCESS,
  GET_USER_MENTEES_ERROR,
  GET_AVAILABLE_MENTEES_BEGIN,
  GET_AVAILABLE_MENTEES_SUCCESS,
  GET_AVAILABLE_MENTEES_ERROR,
  MENTORSHIP_MENTORS_UNMOUNT,
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

/* User Mentors/Mentee */

export function getMentorsBegin(payload) {
  return {
    type: GET_USER_MENTORS_BEGIN,
    payload,
  };
}

export function getMentorsSuccess(payload) {
  return {
    type: GET_USER_MENTORS_SUCCESS,
    payload,
  };
}

export function getMentorsError(error) {
  return {
    type: GET_USER_MENTORS_ERROR,
    error,
  };
}


export function getAvailableMentorsBegin(payload) {
  return {
    type: GET_AVAILABLE_MENTORS_BEGIN,
    payload,
  };
}

export function getAvailableMentorsSuccess(payload) {
  return {
    type: GET_AVAILABLE_MENTORS_SUCCESS,
    payload,
  };
}

export function getAvailableMentorsError(error) {
  return {
    type: GET_AVAILABLE_MENTORS_ERROR,
    error,
  };
}

export function getMenteesBegin(payload) {
  return {
    type: GET_USER_MENTEES_BEGIN,
    payload,
  };
}

export function getMenteesSuccess(payload) {
  return {
    type: GET_USER_MENTEES_SUCCESS,
    payload,
  };
}

export function getMenteesError(error) {
  return {
    type: GET_USER_MENTEES_ERROR,
    error,
  };
}


export function getAvailableMenteesBegin(payload) {
  return {
    type: GET_AVAILABLE_MENTEES_BEGIN,
    payload,
  };
}

export function getAvailableMenteesSuccess(payload) {
  return {
    type: GET_AVAILABLE_MENTEES_SUCCESS,
    payload,
  };
}

export function getAvailableMenteesError(error) {
  return {
    type: GET_AVAILABLE_MENTEES_ERROR,
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

export function mentorsUnmount() {
  return {
    type: MENTORSHIP_MENTORS_UNMOUNT
  };
}
