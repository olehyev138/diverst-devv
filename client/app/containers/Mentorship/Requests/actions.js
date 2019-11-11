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
  DENY_REQUEST_BEGIN,
  DENY_REQUEST_SUCCESS,
  DENY_REQUEST_ERROR,
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
    type: DENY_REQUEST_BEGIN,
    payload,
  };
}

export function rejectRequestSuccess(payload) {
  return {
    type: DENY_REQUEST_SUCCESS,
    payload,
  };
}

export function rejectRequestError(payload) {
  return {
    type: DENY_REQUEST_ERROR,
    payload,
  };
}

export function requestUnmount(payload) {
  return {
    type: REQUEST_UNMOUNT,
    payload,
  };
}
