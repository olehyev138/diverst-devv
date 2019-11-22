/*
 *
 * User actions
 *
 */

import {
  GET_USER_ROLES_BEGIN, GET_USER_ROLES_SUCCESS, GET_USER_ROLES_ERROR,
  GET_USER_ROLE_BEGIN, GET_USER_ROLE_SUCCESS, GET_USER_ROLE_ERROR,
  CREATE_USER_ROLE_BEGIN, CREATE_USER_ROLE_SUCCESS, CREATE_USER_ROLE_ERROR,
  UPDATE_USER_ROLE_BEGIN, UPDATE_USER_ROLE_SUCCESS, UPDATE_USER_ROLE_ERROR,
  DELETE_USER_ROLE_BEGIN, DELETE_USER_ROLE_SUCCESS, DELETE_USER_ROLE_ERROR,
  USER_ROLE_UNMOUNT,
} from 'containers/User/UserRole/constants';

/* User listing */

export function getUserRolesBegin(payload) {
  return {
    type: GET_USER_ROLES_BEGIN,
    payload
  };
}

export function getUserRolesSuccess(payload) {
  return {
    type: GET_USER_ROLES_SUCCESS,
    payload
  };
}

export function getUserRolesError(error) {
  return {
    type: GET_USER_ROLES_ERROR,
    error,
  };
}

/* Getting specific user */

export function getUserRoleBegin(payload) {
  return {
    type: GET_USER_ROLE_BEGIN,
    payload,
  };
}

export function getUserRoleSuccess(payload) {
  return {
    type: GET_USER_ROLE_SUCCESS,
    payload,
  };
}

export function getUserRoleError(error) {
  return {
    type: GET_USER_ROLE_ERROR,
    error,
  };
}

/* User creating */

export function createUserRoleBegin(payload) {
  return {
    type: CREATE_USER_ROLE_BEGIN,
    payload,
  };
}

export function createUserRoleSuccess(payload) {
  return {
    type: CREATE_USER_ROLE_SUCCESS,
    payload,
  };
}

export function createUserRoleError(error) {
  return {
    type: CREATE_USER_ROLE_ERROR,
    error,
  };
}

/* User updating */

export function updateUserRoleBegin(payload) {
  return {
    type: UPDATE_USER_ROLE_BEGIN,
    payload,
  };
}

export function updateUserRoleSuccess(payload) {
  return {
    type: UPDATE_USER_ROLE_SUCCESS,
    payload,
  };
}

export function updateUserRoleError(error) {
  return {
    type: UPDATE_USER_ROLE_ERROR,
    error,
  };
}

/* User deleting */

export function deleteUserRoleBegin(payload) {
  return {
    type: DELETE_USER_ROLE_BEGIN,
    payload,
  };
}

export function deleteUserRoleSuccess(payload) {
  return {
    type: DELETE_USER_ROLE_SUCCESS,
    payload,
  };
}

export function deleteUserRoleError(error) {
  return {
    type: DELETE_USER_ROLE_ERROR,
    error,
  };
}

export function userRoleUnmount() {
  return {
    type: USER_ROLE_UNMOUNT
  };
}
