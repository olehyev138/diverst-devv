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

export function responsesUnmount(payload) {
  return {
    type: RESPONSES_UNMOUNT,
    payload,
  };
}
