/*
 *
 * LoginPage actions
 *
 */

import { HANDLE_LOGIN, LOGIN_ERROR, HANDLE_FIND_ENTERPRISE, FIND_ENTERPRISE_ERROR } from './constants'

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
