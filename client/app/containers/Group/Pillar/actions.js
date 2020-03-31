/*
 *
 * Pillar actions
 *
 */

import {
  GET_PILLAR_BEGIN,
  GET_PILLAR_SUCCESS,
  GET_PILLAR_ERROR,
  GET_PILLARS_BEGIN,
  GET_PILLARS_SUCCESS,
  GET_PILLARS_ERROR,
  CREATE_PILLAR_BEGIN,
  CREATE_PILLAR_SUCCESS,
  CREATE_PILLAR_ERROR,
  UPDATE_PILLAR_BEGIN,
  UPDATE_PILLAR_SUCCESS,
  UPDATE_PILLAR_ERROR,
  DELETE_PILLAR_BEGIN,
  DELETE_PILLAR_SUCCESS,
  DELETE_PILLAR_ERROR,
  PILLARS_UNMOUNT,
} from './constants';

export function getPillarBegin(payload) {
  return {
    type: GET_PILLAR_BEGIN,
    payload,
  };
}

export function getPillarSuccess(payload) {
  return {
    type: GET_PILLAR_SUCCESS,
    payload,
  };
}

export function getPillarError(error) {
  return {
    type: GET_PILLAR_ERROR,
    error,
  };
}

export function getPillarsBegin(payload) {
  return {
    type: GET_PILLARS_BEGIN,
    payload,
  };
}

export function getPillarsSuccess(payload) {
  return {
    type: GET_PILLARS_SUCCESS,
    payload,
  };
}

export function getPillarsError(error) {
  return {
    type: GET_PILLARS_ERROR,
    error,
  };
}

export function createPillarBegin(payload) {
  return {
    type: CREATE_PILLAR_BEGIN,
    payload,
  };
}

export function createPillarSuccess(payload) {
  return {
    type: CREATE_PILLAR_SUCCESS,
    payload,
  };
}

export function createPillarError(error) {
  return {
    type: CREATE_PILLAR_ERROR,
    error,
  };
}

export function updatePillarBegin(payload) {
  return {
    type: UPDATE_PILLAR_BEGIN,
    payload,
  };
}

export function updatePillarSuccess(payload) {
  return {
    type: UPDATE_PILLAR_SUCCESS,
    payload,
  };
}

export function updatePillarError(error) {
  return {
    type: UPDATE_PILLAR_ERROR,
    error,
  };
}

export function deletePillarBegin(payload) {
  return {
    type: DELETE_PILLAR_BEGIN,
    payload,
  };
}

export function deletePillarSuccess(payload) {
  return {
    type: DELETE_PILLAR_SUCCESS,
    payload,
  };
}

export function deletePillarError(error) {
  return {
    type: DELETE_PILLAR_ERROR,
    error,
  };
}

export function pillarsUnmount(payload) {
  return {
    type: PILLARS_UNMOUNT,
    payload,
  };
}
