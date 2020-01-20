/*
 *
 * Fielddata actions
 *
 */

import {
  UPDATE_FIELD_DATA_BEGIN,
  UPDATE_FIELD_DATA_SUCCESS,
  UPDATE_FIELD_DATA_ERROR,
} from './constants';

export function updateFieldDataBegin(payload) {
  return {
    type: UPDATE_FIELD_DATA_BEGIN,
    payload,
  };
}

export function updateFieldDataSuccess(payload) {
  return {
    type: UPDATE_FIELD_DATA_SUCCESS,
    payload,
  };
}

export function updateFieldDataError(error) {
  return {
    type: UPDATE_FIELD_DATA_ERROR,
    error,
  };
}
