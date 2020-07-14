/*
 *
 * Poll actions
 *
 */

import {
  GET_POLL_BEGIN,
  GET_POLL_SUCCESS,
  GET_POLL_ERROR,
  GET_POLLS_BEGIN,
  GET_POLLS_SUCCESS,
  GET_POLLS_ERROR,
  CREATE_POLL_BEGIN,
  CREATE_POLL_SUCCESS,
  CREATE_POLL_ERROR,
  UPDATE_POLL_BEGIN,
  UPDATE_POLL_SUCCESS,
  UPDATE_POLL_ERROR,
  CREATE_POLL_AND_PUBLISH_BEGIN,
  CREATE_POLL_AND_PUBLISH_SUCCESS,
  CREATE_POLL_AND_PUBLISH_ERROR,
  UPDATE_POLL_AND_PUBLISH_BEGIN,
  UPDATE_POLL_AND_PUBLISH_SUCCESS,
  UPDATE_POLL_AND_PUBLISH_ERROR,
  PUBLISH_POLL_BEGIN,
  PUBLISH_POLL_SUCCESS,
  PUBLISH_POLL_ERROR,
  DELETE_POLL_BEGIN,
  DELETE_POLL_SUCCESS,
  DELETE_POLL_ERROR,
  POLLS_UNMOUNT,
} from './constants';

export function getPollBegin(payload) {
  return {
    type: GET_POLL_BEGIN,
    payload,
  };
}

export function getPollSuccess(payload) {
  return {
    type: GET_POLL_SUCCESS,
    payload,
  };
}

export function getPollError(error) {
  return {
    type: GET_POLL_ERROR,
    error,
  };
}

export function getPollsBegin(payload) {
  return {
    type: GET_POLLS_BEGIN,
    payload,
  };
}

export function getPollsSuccess(payload) {
  return {
    type: GET_POLLS_SUCCESS,
    payload,
  };
}

export function getPollsError(error) {
  return {
    type: GET_POLLS_ERROR,
    error,
  };
}

export function createPollBegin(payload) {
  return {
    type: CREATE_POLL_BEGIN,
    payload,
  };
}

export function createPollSuccess(payload) {
  return {
    type: CREATE_POLL_SUCCESS,
    payload,
  };
}

export function createPollError(error) {
  return {
    type: CREATE_POLL_ERROR,
    error,
  };
}

export function updatePollBegin(payload) {
  return {
    type: UPDATE_POLL_BEGIN,
    payload,
  };
}

export function updatePollSuccess(payload) {
  return {
    type: UPDATE_POLL_SUCCESS,
    payload,
  };
}

export function updatePollError(error) {
  return {
    type: UPDATE_POLL_ERROR,
    error,
  };
}

export function createPollAndPublishBegin(payload) {
  return {
    type: CREATE_POLL_AND_PUBLISH_BEGIN,
    payload,
  };
}

export function createPollAndPublishSuccess(payload) {
  return {
    type: CREATE_POLL_AND_PUBLISH_SUCCESS,
    payload,
  };
}

export function createPollAndPublishError(error) {
  return {
    type: CREATE_POLL_AND_PUBLISH_ERROR,
    error,
  };
}

export function updatePollAndPublishBegin(payload) {
  return {
    type: UPDATE_POLL_AND_PUBLISH_BEGIN,
    payload,
  };
}

export function updatePollAndPublishSuccess(payload) {
  return {
    type: UPDATE_POLL_AND_PUBLISH_SUCCESS,
    payload,
  };
}

export function updatePollAndPublishError(error) {
  return {
    type: UPDATE_POLL_AND_PUBLISH_ERROR,
    error,
  };
}

export function publishPollBegin(payload) {
  return {
    type: PUBLISH_POLL_BEGIN,
    payload,
  };
}

export function publishPollSuccess(payload) {
  return {
    type: PUBLISH_POLL_SUCCESS,
    payload,
  };
}

export function publishPollError(error) {
  return {
    type: PUBLISH_POLL_ERROR,
    error,
  };
}

export function deletePollBegin(payload) {
  return {
    type: DELETE_POLL_BEGIN,
    payload,
  };
}

export function deletePollSuccess(payload) {
  return {
    type: DELETE_POLL_SUCCESS,
    payload,
  };
}

export function deletePollError(error) {
  return {
    type: DELETE_POLL_ERROR,
    error,
  };
}

export function pollsUnmount(payload) {
  return {
    type: POLLS_UNMOUNT,
    payload,
  };
}
