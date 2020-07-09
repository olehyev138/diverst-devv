/*
 *
 * PollResponse actions
 *
 */

import {
  GET_QUESTIONNAIRE_BY_TOKEN_BEGIN,
  GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS,
  GET_QUESTIONNAIRE_BY_TOKEN_ERROR,
  SUBMIT_RESPONSE_BEGIN,
  SUBMIT_RESPONSE_SUCCESS,
  SUBMIT_RESPONSE_ERROR,
  POLL_RESPONSE_UNMOUNT,
} from './constants';

export function getQuestionnaireByTokenBegin(payload) {
  return {
    type: GET_QUESTIONNAIRE_BY_TOKEN_BEGIN,
    payload,
  };
}

export function getQuestionnaireByTokenSuccess(payload) {
  return {
    type: GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS,
    payload,
  };
}

export function getQuestionnaireByTokenError(errors) {
  return {
    type: GET_QUESTIONNAIRE_BY_TOKEN_ERROR,
    errors,
  };
}

export function submitResponseBegin(payload) {
  return {
    type: SUBMIT_RESPONSE_BEGIN,
    payload,
  };
}

export function submitResponseSuccess(payload) {
  return {
    type: SUBMIT_RESPONSE_SUCCESS,
    payload,
  };
}

export function submitResponseError(errors) {
  return {
    type: SUBMIT_RESPONSE_ERROR,
    errors,
  };
}

export function pollResponseUnmount(payload) {
  return {
    type: POLL_RESPONSE_UNMOUNT,
    payload,
  };
}
