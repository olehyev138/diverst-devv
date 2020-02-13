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
  SSO_LINK_BEGIN
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

export function logoutBegin(user) {
  return {
    type: LOGOUT_BEGIN,
    token: user.user_token
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


export function setUserData(payload, append = false) {
  return {
    type: SET_USER_DATA,
    payload,
    append,
  };
}
