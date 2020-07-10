import {
  LOGIN_BEGIN,
  LOGIN_SUCCESS,
  LOGIN_ERROR,
  LOGOUT_BEGIN,
  LOGOUT_SUCCESS,
  LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN,
  FIND_ENTERPRISE_SUCCESS,
  FIND_ENTERPRISE_ERROR,
  SET_USER_DATA,
  SSO_LOGIN_BEGIN,
  SSO_LINK_BEGIN,
  FETCH_USER_DATA_BEGIN,
  FETCH_USER_DATA_SUCCESS,
  FETCH_USER_DATA_ERROR,
  TOGGLE_ADMIN_DRAWER
}
  from './constants';

export function loginBegin(payload) {
  return {
    type: LOGIN_BEGIN,
    payload,
  };
}

export function ssoLinkBegin(payload) {
  return {
    type: SSO_LINK_BEGIN,
    payload
  };
}

export function ssoLoginBegin(payload) {
  return {
    type: SSO_LOGIN_BEGIN,
    payload
  };
}

// Action for *after* user has been authenticated
export function loginSuccess(token) {
  return {
    type: LOGIN_SUCCESS,
    token,
  };
}

export function loginError(error) {
  return {
    type: LOGIN_ERROR,
    error
  };
}

export function logoutBegin() {
  return {
    type: LOGOUT_BEGIN,
  };
}

export function logoutSuccess() {
  return {
    type: LOGOUT_SUCCESS,
  };
}

export function logoutError(error) {
  return {
    type: LOGOUT_ERROR,
    error,
  };
}

export function findEnterpriseBegin(payload) {
  return {
    type: FIND_ENTERPRISE_BEGIN,
    payload
  };
}

export function findEnterpriseSuccess() {
  return {
    type: FIND_ENTERPRISE_SUCCESS,
  };
}

export function findEnterpriseError(error) {
  return {
    type: FIND_ENTERPRISE_ERROR,
    error
  };
}

export function fetchUserDataBegin() {
  return {
    type: FETCH_USER_DATA_BEGIN,
  };
}

export function fetchUserDataSuccess() {
  return {
    type: FETCH_USER_DATA_SUCCESS,
  };
}

export function fetchUserDataError(error) {
  return {
    type: FETCH_USER_DATA_ERROR,
    error
  };
}

export function setUserData(payload, append = false) {
  return {
    type: SET_USER_DATA,
    payload,
    append,
  };
}

export function toggleAdminDrawer(setTo = undefined) {
  return {
    type: TOGGLE_ADMIN_DRAWER,
    setTo,
  };
}
