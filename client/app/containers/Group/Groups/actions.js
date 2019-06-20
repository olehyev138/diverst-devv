/*
 *
 * Groups actions
 *
 */

import {
  GET_GROUPS_BEGIN, GET_GROUPS_SUCCESS, GET_GROUPS_ERROR,
  GET_GROUP_BEGIN, GET_GROUP_SUCCESS, GET_GROUP_ERROR,
  CREATE_GROUP_BEGIN, CREATE_GROUP_SUCCESS, CREATE_GROUP_ERROR,
  UPDATE_GROUP_BEGIN, UPDATE_GROUP_SUCCESS, UPDATE_GROUP_ERROR,
  DELETE_GROUP_BEGIN, DELETE_GROUP_SUCCESS, DELETE_GROUP_ERROR,

} from 'containers/Group/Groups/constants';

/* Group listing */

export function getGroupsBegin(payload) {
  return {
    type: GET_GROUPS_BEGIN,
    payload,
  };
}

export function getGroupsSuccess(payload) {
  return {
    type: GET_GROUPS_SUCCESS,
    payload,
  };
}

export function getGroupsError(error) {
  return {
    type: GET_GROUPS_ERROR,
    error,
  };
}

/* Getting specific group */

export function getGroupBegin(payload) {
  return {
    type: GET_GROUP_BEGIN,
    payload,
  };
}

export function getGroupSuccess(payload) {
  return {
    type: GET_GROUP_SUCCESS,
    payload,
  };
}

export function getGroupError(error) {
  return {
    type: GET_GROUP_ERROR,
    error,
  };
}

/* Group creating */

export function createGroupBegin(payload) {
  return {
    type: CREATE_GROUP_BEGIN,
    payload,
  };
}

export function createGroupSuccess(payload) {
  return {
    type: CREATE_GROUP_SUCCESS,
    payload,
  };
}

export function createGroupError(error) {
  return {
    type: CREATE_GROUP_ERROR,
    error,
  };
}

/* Group updating */

export function updateGroupBegin(payload) {
  return {
    type: UPDATE_GROUP_BEGIN,
    payload,
  };
}

export function updateGroupSuccess(payload) {
  return {
    type: UPDATE_GROUP_SUCCESS,
    payload,
  };
}

export function updateGroupError(error) {
  return {
    type: UPDATE_GROUP_ERROR,
    error,
  };
}

/* Group deleting */

export function deleteGroupBegin(payload) {
  return {
    type: DELETE_GROUP_BEGIN,
    payload,
  };
}

export function deleteGroupSuccess(payload) {
  return {
    type: DELETE_GROUP_SUCCESS,
    payload,
  };
}

export function deleteGroupError(error) {
  return {
    type: DELETE_GROUP_ERROR,
    error,
  };
}
