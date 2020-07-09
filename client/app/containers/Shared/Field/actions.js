/*
 *
 * Field actions
 *
 */

import {
  GET_FIELDS_BEGIN, GET_FIELDS_SUCCESS, GET_FIELDS_ERROR,
  GET_FIELD_BEGIN, GET_FIELD_SUCCESS, GET_FIELD_ERROR,
  CREATE_FIELD_BEGIN, CREATE_FIELD_SUCCESS, CREATE_FIELD_ERROR,
  UPDATE_FIELD_BEGIN, UPDATE_FIELD_SUCCESS, UPDATE_FIELD_ERROR,
  DELETE_FIELD_BEGIN, DELETE_FIELD_SUCCESS, DELETE_FIELD_ERROR,
  FIELD_LIST_UNMOUNT, FIELD_FORM_UNMOUNT, UPDATE_FIELD_POSITION_BEGIN,
  UPDATE_FIELD_POSITION_ERROR, UPDATE_FIELD_POSITION_SUCCESS,
} from 'containers/Shared/Field/constants';

/* Field listing */

export function getFieldsBegin(payload) {
  return {
    type: GET_FIELDS_BEGIN,
    payload
  };
}

export function getFieldsSuccess(payload) {
  return {
    type: GET_FIELDS_SUCCESS,
    payload
  };
}

export function getFieldsError(error) {
  return {
    type: GET_FIELDS_ERROR,
    error,
  };
}

/* Getting specific field */

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

/* Field creating */

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

/* Field updating */

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

/* Field deleting */

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

export function fieldUnmount() {
  return {
    type: FIELD_LIST_UNMOUNT
  };
}

export function updateFieldPositionBegin(payload) {
  return {
    type: UPDATE_FIELD_POSITION_BEGIN,
    payload,
  };
}

export function updateFieldPositionSuccess(payload) {
  return {
    type: UPDATE_FIELD_POSITION_SUCCESS,
    payload,
  };
}

export function updateFieldPositionError(error) {
  return {
    type: UPDATE_FIELD_POSITION_ERROR,
    error,
  };
}
