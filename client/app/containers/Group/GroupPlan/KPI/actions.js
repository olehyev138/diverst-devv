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
  GET_FIELD_BEGIN,
  GET_FIELD_SUCCESS,
  GET_FIELD_ERROR,
  GET_FIELDS_BEGIN,
  GET_FIELDS_SUCCESS,
  GET_FIELDS_ERROR,
  CREATE_FIELD_BEGIN,
  CREATE_FIELD_SUCCESS,
  CREATE_FIELD_ERROR,
  UPDATE_FIELD_BEGIN,
  UPDATE_FIELD_SUCCESS,
  UPDATE_FIELD_ERROR,
  DELETE_FIELD_BEGIN,
  DELETE_FIELD_SUCCESS,
  DELETE_FIELD_ERROR,
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

export function getFieldBegin(payload) {
  return {
    type: GET_FIELD_BEGIN,
    payload,
  };
}

export function getFieldSuccess(payload) {
  return {
    type: GET_FIELD_SUCCESS,
    payload,
  };
}

export function getFieldError(error) {
  return {
    type: GET_FIELD_ERROR,
    error,
  };
}

export function getFieldsBegin(payload) {
  return {
    type: GET_FIELDS_BEGIN,
    payload,
  };
}

export function getFieldsSuccess(payload) {
  return {
    type: GET_FIELDS_SUCCESS,
    payload,
  };
}

export function getFieldsError(error) {
  return {
    type: GET_FIELDS_ERROR,
    error,
  };
}

export function createFieldBegin(payload) {
  return {
    type: CREATE_FIELD_BEGIN,
    payload,
  };
}

export function createFieldSuccess(payload) {
  return {
    type: CREATE_FIELD_SUCCESS,
    payload,
  };
}

export function createFieldError(error) {
  return {
    type: CREATE_FIELD_ERROR,
    error,
  };
}

export function updateFieldBegin(payload) {
  return {
    type: UPDATE_FIELD_BEGIN,
    payload,
  };
}

export function updateFieldSuccess(payload) {
  return {
    type: UPDATE_FIELD_SUCCESS,
    payload,
  };
}

export function updateFieldError(error) {
  return {
    type: UPDATE_FIELD_ERROR,
    error,
  };
}

export function deleteFieldBegin(payload) {
  return {
    type: DELETE_FIELD_BEGIN,
    payload,
  };
}

export function deleteFieldSuccess(payload) {
  return {
    type: DELETE_FIELD_SUCCESS,
    payload,
  };
}

export function deleteFieldError(error) {
  return {
    type: DELETE_FIELD_ERROR,
    error,
  };
}

export function fieldsUnmount(payload) {
  return {
    type: FIELDS_UNMOUNT,
    payload,
  };
}
