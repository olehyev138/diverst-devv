/*
 *
 * Campaign actions
 *
 */

import {
  GET_GROUP_LEADERS_BEGIN, GET_GROUP_LEADERS_SUCCESS, GET_GROUP_LEADERS_ERROR,
  GET_GROUP_LEADER_BEGIN, GET_GROUP_LEADER_SUCCESS, GET_GROUP_LEADER_ERROR,
  CREATE_GROUP_LEADER_BEGIN, CREATE_GROUP_LEADER_SUCCESS, CREATE_GROUP_LEADER_ERROR,
  UPDATE_GROUP_LEADER_BEGIN, UPDATE_GROUP_LEADER_SUCCESS, UPDATE_GROUP_LEADER_ERROR,
  DELETE_GROUP_LEADER_BEGIN, DELETE_GROUP_LEADER_SUCCESS, DELETE_GROUP_LEADER_ERROR,
  GROUP_LEADERS_UNMOUNT
} from './constants';

/* Campaign listing */

export function getGroupLeadersBegin(payload) {
  return {
    type: GET_GROUP_LEADERS_BEGIN,
    payload
  };
}

export function getGroupLeadersSuccess(payload) {
  return {
    type: GET_GROUP_LEADERS_SUCCESS,
    payload
  };
}

export function getGroupLeadersError(error) {
  return {
    type: GET_GROUP_LEADERS_ERROR,
    error,
  };
}

/* Group Leader Getting */

export function getGroupLeaderBegin(payload) {
  return {
    type: GET_GROUP_LEADER_BEGIN,
    payload
  };
}

export function getGroupLeaderSuccess(payload) {
  return {
    type: GET_GROUP_LEADER_SUCCESS,
    payload
  };
}

export function getGroupLeaderError(error) {
  return {
    type: GET_GROUP_LEADER_ERROR,
    error,
  };
}

/* Group Leader creating */

export function createGroupLeaderBegin(payload) {
  return {
    type: CREATE_GROUP_LEADER_BEGIN,
    payload,
  };
}

export function createGroupLeaderSuccess(payload) {
  return {
    type: CREATE_GROUP_LEADER_SUCCESS,
    payload,
  };
}

export function createGroupLeaderError(error) {
  return {
    type: CREATE_GROUP_LEADER_ERROR,
    error,
  };
}

/* Group Leader updating */

export function updateGroupLeaderBegin(payload) {
  return {
    type: UPDATE_GROUP_LEADER_BEGIN,
    payload,
  };
}

export function updateGroupLeaderSuccess(payload) {
  return {
    type: UPDATE_GROUP_LEADER_SUCCESS,
    payload,
  };
}

export function updateGroupLeaderError(error) {
  return {
    type: UPDATE_GROUP_LEADER_ERROR,
    error,
  };
}

/* Group Leader deleting */

export function deleteGroupLeaderBegin(payload) {
  return {
    type: DELETE_GROUP_LEADER_BEGIN,
    payload,
  };
}

export function deleteGroupLeaderSuccess(payload) {
  return {
    type: DELETE_GROUP_LEADER_SUCCESS,
    payload,
  };
}

export function deleteGroupLeaderError(error) {
  return {
    type: DELETE_GROUP_LEADER_ERROR,
    error,
  };
}

export function groupLeadersUnmount() {
  return {
    type: GROUP_LEADERS_UNMOUNT
  };
}
