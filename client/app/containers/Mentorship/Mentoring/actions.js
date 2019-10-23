/*
 *
 * Mentorings actions
 *
 */

import {
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
} from 'containers/Mentorship/Mentoring/constants';

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

export function mentorsUnmount() {
  return {
    type: MENTORSHIP_MENTORS_UNMOUNT
  };
}
