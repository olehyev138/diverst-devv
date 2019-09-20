/*
 *
 * Custom Text actions
 *
 */

import {
  UPDATE_CUSTOM_TEXT_BEGIN, UPDATE_CUSTOM_TEXT_SUCCESS, UPDATE_CUSTOM_TEXT_ERROR,
  CUSTOM_TEXT_UNMOUNT
} from 'containers/GlobalSettings/CustomText/constants';

/* Group Message updating */

export function updateCustomTextBegin(payload) {
  return {
    type: UPDATE_CUSTOM_TEXT_BEGIN,
    payload,
  };
}

export function updateCustomTextSuccess(payload) {
  return {
    type: UPDATE_CUSTOM_TEXT_SUCCESS,
    payload,
  };
}

export function updateCustomTextError(error) {
  return {
    type: UPDATE_CUSTOM_TEXT_ERROR,
    error,
  };
}
