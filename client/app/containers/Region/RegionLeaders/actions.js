/*
 *
 * Campaign actions
 *
 */

import {
  GET_REGION_LEADERS_BEGIN, GET_REGION_LEADERS_SUCCESS, GET_REGION_LEADERS_ERROR,
  GET_REGION_LEADER_BEGIN, GET_REGION_LEADER_SUCCESS, GET_REGION_LEADER_ERROR,
  CREATE_REGION_LEADER_BEGIN, CREATE_REGION_LEADER_SUCCESS, CREATE_REGION_LEADER_ERROR,
  UPDATE_REGION_LEADER_BEGIN, UPDATE_REGION_LEADER_SUCCESS, UPDATE_REGION_LEADER_ERROR,
  DELETE_REGION_LEADER_BEGIN, DELETE_REGION_LEADER_SUCCESS, DELETE_REGION_LEADER_ERROR,
  REGION_LEADERS_UNMOUNT
} from './constants';

/* Region Leader listing */

export function getRegionLeadersBegin(payload) {
  return {
    type: GET_REGION_LEADERS_BEGIN,
    payload
  };
}

export function getRegionLeadersSuccess(payload) {
  return {
    type: GET_REGION_LEADERS_SUCCESS,
    payload
  };
}

export function getRegionLeadersError(error) {
  return {
    type: GET_REGION_LEADERS_ERROR,
    error,
  };
}

/* Region Leader Getting */

export function getRegionLeaderBegin(payload) {
  return {
    type: GET_REGION_LEADER_BEGIN,
    payload
  };
}

export function getRegionLeaderSuccess(payload) {
  return {
    type: GET_REGION_LEADER_SUCCESS,
    payload
  };
}

export function getRegionLeaderError(error) {
  return {
    type: GET_REGION_LEADER_ERROR,
    error,
  };
}

/* Region Leader creating */

export function createRegionLeaderBegin(payload) {
  return {
    type: CREATE_REGION_LEADER_BEGIN,
    payload,
  };
}

export function createRegionLeaderSuccess(payload) {
  return {
    type: CREATE_REGION_LEADER_SUCCESS,
    payload,
  };
}

export function createRegionLeaderError(error) {
  return {
    type: CREATE_REGION_LEADER_ERROR,
    error,
  };
}

/* Region Leader updating */

export function updateRegionLeaderBegin(payload) {
  return {
    type: UPDATE_REGION_LEADER_BEGIN,
    payload,
  };
}

export function updateRegionLeaderSuccess(payload) {
  return {
    type: UPDATE_REGION_LEADER_SUCCESS,
    payload,
  };
}

export function updateRegionLeaderError(error) {
  return {
    type: UPDATE_REGION_LEADER_ERROR,
    error,
  };
}

/* Region Leader deleting */

export function deleteRegionLeaderBegin(payload) {
  return {
    type: DELETE_REGION_LEADER_BEGIN,
    payload,
  };
}

export function deleteRegionLeaderSuccess(payload) {
  return {
    type: DELETE_REGION_LEADER_SUCCESS,
    payload,
  };
}

export function deleteRegionLeaderError(error) {
  return {
    type: DELETE_REGION_LEADER_ERROR,
    error,
  };
}

export function regionLeadersUnmount() {
  return {
    type: REGION_LEADERS_UNMOUNT
  };
}
