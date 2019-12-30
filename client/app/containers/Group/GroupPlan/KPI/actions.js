/*
 *
 * Kpi actions
 *
 */

import {
  GET_UPDATE_BEGIN,
  GET_UPDATE_SUCCESS,
  GET_UPDATE_ERROR,
  GET_UPDATES_BEGIN,
  GET_UPDATES_SUCCESS,
  GET_UPDATES_ERROR,
  CREATE_UPDATE_BEGIN,
  CREATE_UPDATE_SUCCESS,
  CREATE_UPDATE_ERROR,
  UPDATE_UPDATE_BEGIN,
  UPDATE_UPDATE_SUCCESS,
  UPDATE_UPDATE_ERROR,
  DELETE_UPDATE_BEGIN,
  DELETE_UPDATE_SUCCESS,
  DELETE_UPDATE_ERROR,
  FIELDS_UNMOUNT,
} from './constants';

export function getUpdateBegin(payload) {
  return {
    type: GET_UPDATE_BEGIN,
    payload,
  };
}

export function getUpdateSuccess(payload) {
  return {
    type: GET_UPDATE_SUCCESS,
    payload,
  };
}

export function getUpdateError(error) {
  return {
    type: GET_UPDATE_ERROR,
    error,
  };
}

export function getUpdatesBegin(payload) {
  return {
    type: GET_UPDATES_BEGIN,
    payload,
  };
}

export function getUpdatesSuccess(payload) {
  return {
    type: GET_UPDATES_SUCCESS,
    payload,
  };
}

export function getUpdatesError(error) {
  return {
    type: GET_UPDATES_ERROR,
    error,
  };
}

export function createUpdateBegin(payload) {
  return {
    type: CREATE_UPDATE_BEGIN,
    payload,
  };
}

export function createUpdateSuccess(payload) {
  return {
    type: CREATE_UPDATE_SUCCESS,
    payload,
  };
}

export function createUpdateError(error) {
  return {
    type: CREATE_UPDATE_ERROR,
    error,
  };
}

export function updateUpdateBegin(payload) {
  return {
    type: UPDATE_UPDATE_BEGIN,
    payload,
  };
}

export function updateUpdateSuccess(payload) {
  return {
    type: UPDATE_UPDATE_SUCCESS,
    payload,
  };
}

export function updateUpdateError(error) {
  return {
    type: UPDATE_UPDATE_ERROR,
    error,
  };
}

export function deleteUpdateBegin(payload) {
  return {
    type: DELETE_UPDATE_BEGIN,
    payload,
  };
}

export function deleteUpdateSuccess(payload) {
  return {
    type: DELETE_UPDATE_SUCCESS,
    payload,
  };
}

export function deleteUpdateError(error) {
  return {
    type: DELETE_UPDATE_ERROR,
    error,
  };
}

export function fieldsUnmount(payload) {
  return {
    type: FIELDS_UNMOUNT,
    payload,
  };
}
