/*
 *
 * Group actions
 *
 */

import {
  GET_USERS_BEGIN, GET_USERS_SUCCESS, GET_USERS_ERROR,
  CREATE_USER_BEGIN, CREATE_USER_SUCCESS, CREATE_USER_ERROR,
  UPDATE_USER_BEGIN, UPDATE_USER_SUCCESS, UPDATE_USER_ERROR,
  DELETE_USER_BEGIN, DELETE_USER_SUCCESS, DELETE_USER_ERROR,
  USER_LIST_UNMOUNT, USER_FORM_UNMOUNT
} from 'containers/Group/GroupMembers/constants';

/* User listing */

export function getUsersBegin(payload) {
  return {
    type: GET_USERS_BEGIN,
    payload
  };
}

export function getUsersSuccess(payload) {
  return {
    type: GET_USERS_SUCCESS,
    payload
  };
}

export function getUsersError(error) {
  return {
    type: GET_USERS_ERROR,
    error,
  };
}

/* Group creating */

export function createUserBegin(payload) {
  return {
    type: CREATE_USER_BEGIN,
    payload,
  };
}

export function createUserSuccess(payload) {
  return {
    type: CREATE_USER_SUCCESS,
    payload,
  };
}

export function createUserError(error) {
  return {
    type: CREATE_USER_ERROR,
    error,
  };
}

/* User updating */

export function updateUserBegin(payload) {
  return {
    type: UPDATE_USER_BEGIN,
    payload,
  };
}

export function updateUserSuccess(payload) {
  return {
    type: UPDATE_USER_SUCCESS,
    payload,
  };
}

export function updateUserError(error) {
  return {
    type: UPDATE_USER_ERROR,
    error,
  };
}

/* User deleting */

export function deleteUserBegin(payload) {
  return {
    type: DELETE_USER_BEGIN,
    payload,
  };
}

export function deleteUserSuccess(payload) {
  return {
    type: DELETE_USER_SUCCESS,
    payload,
  };
}

export function deleteUserError(error) {
  return {
    type: DELETE_USER_ERROR,
    error,
  };
}

export function userListUnmount() {
  return {
    type: USER_LIST_UNMOUNT
  };
}

export function userFormUnmount() {
  return {
    type: USER_FORM_UNMOUNT
  };
}
