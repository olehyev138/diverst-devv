/*
 *
 * Outcome actions
 *
 */

import {
  GET_OUTCOMES_BEGIN, GET_OUTCOMES_SUCCESS, GET_OUTCOMES_ERROR,
  GET_OUTCOME_BEGIN, GET_OUTCOME_SUCCESS, GET_OUTCOME_ERROR,
  CREATE_OUTCOME_BEGIN, CREATE_OUTCOME_SUCCESS, CREATE_OUTCOME_ERROR,
  UPDATE_OUTCOME_BEGIN, UPDATE_OUTCOME_SUCCESS, UPDATE_OUTCOME_ERROR,
  DELETE_OUTCOME_BEGIN, DELETE_OUTCOME_SUCCESS, DELETE_OUTCOME_ERROR,
  OUTCOMES_UNMOUNT,
} from 'containers/Group/Outcome/constants';

/* Outcome listing */

export function getOutcomesBegin(payload) {
  return {
    type: GET_OUTCOMES_BEGIN,
    payload
  };
}

export function getOutcomesSuccess(payload) {
  return {
    type: GET_OUTCOMES_SUCCESS,
    payload
  };
}

export function getOutcomesError(error) {
  return {
    type: GET_OUTCOMES_ERROR,
    error,
  };
}

/* Getting specific outcome */

export function getOutcomeBegin(payload) {
  return {
    type: GET_OUTCOME_BEGIN,
    payload,
  };
}

export function getOutcomeSuccess(payload) {
  return {
    type: GET_OUTCOME_SUCCESS,
    payload,
  };
}

export function getOutcomeError(error) {
  return {
    type: GET_OUTCOME_ERROR,
    error,
  };
}

/* Outcome creating */

export function createOutcomeBegin(payload) {
  return {
    type: CREATE_OUTCOME_BEGIN,
    payload,
  };
}

export function createOutcomeSuccess(payload) {
  return {
    type: CREATE_OUTCOME_SUCCESS,
    payload,
  };
}

export function createOutcomeError(error) {
  return {
    type: CREATE_OUTCOME_ERROR,
    error,
  };
}

/* Outcome updating */

export function updateOutcomeBegin(payload) {
  return {
    type: UPDATE_OUTCOME_BEGIN,
    payload,
  };
}

export function updateOutcomeSuccess(payload) {
  return {
    type: UPDATE_OUTCOME_SUCCESS,
    payload,
  };
}

export function updateOutcomeError(error) {
  return {
    type: UPDATE_OUTCOME_ERROR,
    error,
  };
}

/* Outcome deleting */

export function deleteOutcomeBegin(payload) {
  return {
    type: DELETE_OUTCOME_BEGIN,
    payload,
  };
}

export function deleteOutcomeSuccess(payload) {
  return {
    type: DELETE_OUTCOME_SUCCESS,
    payload,
  };
}

export function deleteOutcomeError(error) {
  return {
    type: DELETE_OUTCOME_ERROR,
    error,
  };
}

export function outcomesUnmount() {
  return {
    type: OUTCOMES_UNMOUNT
  };
}
