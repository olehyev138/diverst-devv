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
  DELETE_MENTORSHIP_BEGIN,
  DELETE_MENTORSHIP_SUCCESS,
  DELETE_MENTORSHIP_ERROR,
  MENTORSHIP_MENTORS_UNMOUNT,
  REQUEST_MENTORSHIP_BEGIN,
  REQUEST_MENTORSHIP_SUCCESS,
  REQUEST_MENTORSHIP_ERROR,
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

export function deleteMentorshipBegin(payload) {
  return {
    type: DELETE_MENTORSHIP_BEGIN,
    payload,
  };
}

export function deleteMentorshipSuccess(payload) {
  return {
    type: DELETE_MENTORSHIP_SUCCESS,
    payload,
  };
}

export function deleteMentorshipError(error) {
  return {
    type: DELETE_MENTORSHIP_ERROR,
    error,
  };
}

export function requestsMentorshipBegin(payload) {
  return {
    type: REQUEST_MENTORSHIP_BEGIN,
    payload,
  };
}

export function requestsMentorshipSuccess(payload) {
  return {
    type: REQUEST_MENTORSHIP_SUCCESS,
    payload,
  };
}

export function requestsMentorshipError(error) {
  return {
    type: REQUEST_MENTORSHIP_ERROR,
    error,
  };
}

export function mentorsUnmount() {
  return {
    type: MENTORSHIP_MENTORS_UNMOUNT
  };
}
