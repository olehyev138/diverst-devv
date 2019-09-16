/*
 *
 * Custom Text actions
 *
 */

import {
  GET_CUSTOM_TEXT_BEGIN, GET_CUSTOM_TEXT_SUCCESS, GET_CUSTOM_TEXT_ERROR,
  UPDATE_CUSTOM_TEXT_BEGIN, UPDATE_CUSTOM_TEXT_SUCCESS, UPDATE_CUSTOM_TEXT_ERROR,
  CUSTOM_TEXT_UNMOUNT
} from 'containers/GlobalSettings/CustomText/constants';

export function getCustomTextBegin(payload) {
  return {
    type: GET_CUSTOM_TEXT_BEGIN,
    payload
  };
}

export function getCustomTextSuccess(payload) {
  return {
    type: GET_CUSTOM_TEXT_SUCCESS,
    payload
  };
}

export function getCustomTextError(error) {
  return {
    type: GET_CUSTOM_TEXT_ERROR,
    error,
  };
}

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

export function customTextUnmount() {
  return {
    type: CUSTOM_TEXT_UNMOUNT,
  };
}
