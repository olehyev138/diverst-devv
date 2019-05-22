import {
  LOGIN_BEGIN, LOGIN_SUCCESS, LOGIN_ERROR,
  LOGOUT_BEGIN, LOGOUT_SUCCESS, LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN, SET_ENTERPRISE, FIND_ENTERPRISE_ERROR,
  SET_USER
} from './constants';

export function loginBegin(payload) {
  return {
    type: LOGIN_BEGIN,
    payload: payload,
  };
}

// Action for *after* user has been authenticated
export function loginSuccess(token) {
  return {
    type: LOGIN_SUCCESS,
    token: token,
  };
}

export function loginError(error) {
  return {
    type: LOGIN_ERROR,
    error: error
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
    error: error,
  };
}

export function findEnterpriseBegin(payload) {
  return {
    type: FIND_ENTERPRISE_BEGIN,
    payload: payload
  };
}

export function setEnterprise(enterprise) {
  return {
    type: SET_ENTERPRISE,
    enterprise: enterprise,
  };
}

export function findEnterpriseError(error) {
 return {
    type: FIND_ENTERPRISE_ERROR,
    error: error
  };
}

export function setUser(user) {
  return {
    type: SET_USER,
    user: user,
  };
}
