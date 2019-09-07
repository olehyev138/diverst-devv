import {
  LOGIN_BEGIN, LOGIN_SUCCESS, LOGIN_ERROR,
  LOGOUT_BEGIN, LOGOUT_SUCCESS, LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN, FIND_ENTERPRISE_SUCCESS, FIND_ENTERPRISE_ERROR,
  SET_ENTERPRISE, SET_USER_POLICY_GROUP, SET_USER
} from './constants';

export function loginBegin(payload) {
  return {
    type: LOGIN_BEGIN,
    payload,
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


export function setEnterprise(enterprise) {
  return {
    type: SET_ENTERPRISE,
    enterprise,
  };
}

export function setUserPolicyGroup(policyGroup) {
  return {
    type: SET_USER_POLICY_GROUP,
    policyGroup,
  };
}

export function setUser(user) {
  return {
    type: SET_USER,
    user,
  };
}
