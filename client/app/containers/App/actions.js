import { LOGGED_IN, LOG_OUT, LOG_OUT_ERROR, SET_USER, SET_ENTERPRISE } from './constants';

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

export function handleLogOut(user) {
  return {
    type: LOG_OUT,
    token: user.user_token
  };
}

export function loggingOutError(error) {
  return {
    type: LOG_OUT_ERROR,
    error: error,
  };
}
