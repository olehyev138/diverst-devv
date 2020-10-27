/*
 *
 * Region actions
 *
 */

import {
  GET_REGIONS_BEGIN,
  GET_REGIONS_SUCCESS,
  GET_REGIONS_ERROR,
  GET_REGION_BEGIN,
  GET_REGION_SUCCESS,
  GET_REGION_ERROR,
  CREATE_REGION_BEGIN,
  CREATE_REGION_SUCCESS,
  CREATE_REGION_ERROR,
  UPDATE_REGION_BEGIN,
  UPDATE_REGION_SUCCESS,
  UPDATE_REGION_ERROR,
  DELETE_REGION_BEGIN,
  DELETE_REGION_SUCCESS,
  DELETE_REGION_ERROR,
  REGION_LIST_UNMOUNT,
  REGION_FORM_UNMOUNT,
  REGION_ALL_UNMOUNT,
} from 'containers/Region/constants';


/* Region listing */
export function getRegionsBegin(payload) {
  return {
    type: GET_REGIONS_BEGIN,
    payload,
  };
}

export function getRegionsSuccess(payload) {
  return {
    type: GET_REGIONS_SUCCESS,
    payload,
  };
}

export function getRegionsError(error) {
  return {
    type: GET_REGIONS_ERROR,
    error,
  };
}

export function getRegionBegin(payload) {
  return {
    type: GET_REGION_BEGIN,
    payload,
  };
}

export function getRegionSuccess(payload) {
  return {
    type: GET_REGION_SUCCESS,
    payload,
  };
}

export function getRegionError(error) {
  return {
    type: GET_REGION_ERROR,
    error,
  };
}

export function createRegionBegin(payload) {
  return {
    type: CREATE_REGION_BEGIN,
    payload,
  };
}

export function createRegionSuccess(payload) {
  return {
    type: CREATE_REGION_SUCCESS,
    payload,
  };
}

export function createRegionError(error) {
  return {
    type: CREATE_REGION_ERROR,
    error,
  };
}

export function updateRegionBegin(payload) {
  return {
    type: UPDATE_REGION_BEGIN,
    payload,
  };
}

export function updateRegionSuccess(payload) {
  return {
    type: UPDATE_REGION_SUCCESS,
    payload,
  };
}

export function updateRegionError(error) {
  return {
    type: UPDATE_REGION_ERROR,
    error,
  };
}

export function deleteRegionBegin(payload) {
  return {
    type: DELETE_REGION_BEGIN,
    payload,
  };
}

export function deleteRegionSuccess(payload) {
  return {
    type: DELETE_REGION_SUCCESS,
    payload,
  };
}

export function deleteRegionError(error) {
  return {
    type: DELETE_REGION_ERROR,
    error,
  };
}

export function regionAllUnmount(payload) {
  return {
    type: REGION_ALL_UNMOUNT,
    payload,
  };
}

export function regionListUnmount(payload) {
  return {
    type: REGION_LIST_UNMOUNT,
    payload,
  };
}

export function regionFormUnmount(payload) {
  return {
    type: REGION_FORM_UNMOUNT,
    payload,
  };
}
