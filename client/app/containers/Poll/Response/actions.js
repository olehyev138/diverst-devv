/*
 *
 * Response actions
 *
 */

import {
  GET_RESPONSE_BEGIN,
  GET_RESPONSE_SUCCESS,
  GET_RESPONSE_ERROR,
  GET_RESPONSES_BEGIN,
  GET_RESPONSES_SUCCESS,
  GET_RESPONSES_ERROR,
  CREATE_RESPONSE_BEGIN,
  CREATE_RESPONSE_SUCCESS,
  CREATE_RESPONSE_ERROR,
  UPDATE_RESPONSE_BEGIN,
  UPDATE_RESPONSE_SUCCESS,
  UPDATE_RESPONSE_ERROR,
  DELETE_RESPONSE_BEGIN,
  DELETE_RESPONSE_SUCCESS,
  DELETE_RESPONSE_ERROR,
  RESPONSES_UNMOUNT,
} from './constants';

export function getResponseBegin(payload) {
  return {
    type: GET_RESPONSE_BEGIN,
    payload,
  };
}

export function getResponseSuccess(payload) {
  return {
    type: GET_RESPONSE_SUCCESS,
    payload,
  };
}

export function getResponseError(error) {
  return {
    type: GET_RESPONSE_ERROR,
    error,
  };
}

export function getResponsesBegin(payload) {
  return {
    type: GET_RESPONSES_BEGIN,
    payload,
  };
}

export function getResponsesSuccess(payload) {
  return {
    type: GET_RESPONSES_SUCCESS,
    payload,
  };
}

export function getResponsesError(error) {
  return {
    type: GET_RESPONSES_ERROR,
    error,
  };
}

export function createResponseBegin(payload) {
  return {
    type: CREATE_RESPONSE_BEGIN,
    payload,
  };
}

export function createResponseSuccess(payload) {
  return {
    type: CREATE_RESPONSE_SUCCESS,
    payload,
  };
}

export function createResponseError(error) {
  return {
    type: CREATE_RESPONSE_ERROR,
    error,
  };
}

export function updateResponseBegin(payload) {
  return {
    type: UPDATE_RESPONSE_BEGIN,
    payload,
  };
}

export function updateResponseSuccess(payload) {
  return {
    type: UPDATE_RESPONSE_SUCCESS,
    payload,
  };
}

export function updateResponseError(error) {
  return {
    type: UPDATE_RESPONSE_ERROR,
    error,
  };
}

export function deleteResponseBegin(payload) {
  return {
    type: DELETE_RESPONSE_BEGIN,
    payload,
  };
}

export function deleteResponseSuccess(payload) {
  return {
    type: DELETE_RESPONSE_SUCCESS,
    payload,
  };
}

export function deleteResponseError(error) {
  return {
    type: DELETE_RESPONSE_ERROR,
    error,
  };
}

export function responsesUnmount(payload) {
  return {
    type: RESPONSES_UNMOUNT,
    payload,
  };
}
