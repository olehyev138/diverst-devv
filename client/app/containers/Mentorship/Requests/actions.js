/*
 *
 * Request actions
 *
 */

import {
  GET_REQUESTS_BEGIN,
  GET_REQUESTS_SUCCESS,
  GET_REQUESTS_ERROR,
  GET_PROPOSALS_BEGIN,
  GET_PROPOSALS_SUCCESS,
  GET_PROPOSALS_ERROR,
  ACCEPT_REQUEST_BEGIN,
  ACCEPT_REQUEST_SUCCESS,
  ACCEPT_REQUEST_ERROR,
  REJECT_REQUEST_BEGIN,
  REJECT_REQUEST_SUCCESS,
  REJECT_REQUEST_ERROR,
  DELETE_REQUEST_BEGIN,
  DELETE_REQUEST_SUCCESS,
  DELETE_REQUEST_ERROR,
  REQUEST_UNMOUNT,
} from './constants';

export function getRequestsBegin(payload) {
  return {
    type: GET_REQUESTS_BEGIN,
    payload,
  };
}

export function getRequestsSuccess(payload) {
  return {
    type: GET_REQUESTS_SUCCESS,
    payload,
  };
}

export function getRequestsError(payload) {
  return {
    type: GET_REQUESTS_ERROR,
    payload,
  };
}

export function getProposalsBegin(payload) {
  return {
    type: GET_PROPOSALS_BEGIN,
    payload,
  };
}

export function getProposalsSuccess(payload) {
  return {
    type: GET_PROPOSALS_SUCCESS,
    payload,
  };
}

export function getProposalsError(payload) {
  return {
    type: GET_PROPOSALS_ERROR,
    payload,
  };
}

export function acceptRequestBegin(payload) {
  return {
    type: ACCEPT_REQUEST_BEGIN,
    payload,
  };
}

export function acceptRequestSuccess(payload) {
  return {
    type: ACCEPT_REQUEST_SUCCESS,
    payload,
  };
}

export function acceptRequestError(payload) {
  return {
    type: ACCEPT_REQUEST_ERROR,
    payload,
  };
}

export function rejectRequestBegin(payload) {
  return {
    type: REJECT_REQUEST_BEGIN,
    payload,
  };
}

export function rejectRequestSuccess(payload) {
  return {
    type: REJECT_REQUEST_SUCCESS,
    payload,
  };
}

export function rejectRequestError(payload) {
  return {
    type: REJECT_REQUEST_ERROR,
    payload,
  };
}

export function deleteRequestBegin(payload) {
  return {
    type: DELETE_REQUEST_BEGIN,
    payload,
  };
}

export function deleteRequestSuccess(payload) {
  return {
    type: DELETE_REQUEST_SUCCESS,
    payload,
  };
}

export function deleteRequestError(payload) {
  return {
    type: DELETE_REQUEST_ERROR,
    payload,
  };
}

export function requestUnmount(payload) {
  return {
    type: REQUEST_UNMOUNT,
    payload,
  };
}
