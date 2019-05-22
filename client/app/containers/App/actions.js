import {
  HANDLE_LOGIN, LOGIN_ERROR, HANDLE_FIND_ENTERPRISE,
  FIND_ENTERPRISE_ERROR, LOGGED_IN, LOG_OUT, LOG_OUT_ERROR,
  SET_USER, SET_ENTERPRISE
} from './constants';

export function handleLogin(payload) {
  return {
    type: HANDLE_LOGIN,
    payload: payload,
  };
}

export function loginError(error) {
  return {
    type: LOGIN_ERROR,
    error: error
  };
}

export function handleFindEnterprise(payload) {
  return {
    type: HANDLE_FIND_ENTERPRISE,
    payload: payload
  };
}

export function findEnterpriseError(error) {
  return {
    type: FIND_ENTERPRISE_ERROR,
    error: error
  };
}



// Action for *after* user has been authenticated
export function loggedIn(token) {
  return {
    type: LOGGED_IN,
    token: token,
  };
}

export function setUser(user) {
  return {
    type: SET_USER,
    user: user,
  };
}

export function setEnterprise(enterprise) {
  return {
    type: SET_ENTERPRISE,
    enterprise: enterprise,
  };
}

export function handleLogOut(token) {
  console.log(token);
  return {
    type: LOG_OUT,
    token: token
  };
}

export function loggingOutError(error) {
  return {
    type: LOG_OUT_ERROR,
    error: error,
  };
}
