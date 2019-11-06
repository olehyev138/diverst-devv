/*
 *
 * Enterprise configuration actions
 *
 */

import {
  GET_ENTERPRISE_BEGIN, GET_ENTERPRISE_SUCCESS, GET_ENTERPRISE_ERROR,
  UPDATE_ENTERPRISE_BEGIN, UPDATE_ENTERPRISE_SUCCESS, UPDATE_ENTERPRISE_ERROR,
  CONFIGURATION_UNMOUNT
} from 'containers/GlobalSettings/EnterpriseConfiguration/constants';

/* Getting enterprise */

export function getEnterpriseBegin(payload) {
  return {
    type: GET_ENTERPRISE_BEGIN,
    payload,
  };
}

export function getEnterpriseSuccess(payload) {
  return {
    type: GET_ENTERPRISE_SUCCESS,
    payload,
  };
}

export function getEnterpriseError(error) {
  return {
    type: GET_ENTERPRISE_ERROR,
    error,
  };
}

/* Enterprise updating */

export function updateEnterpriseBegin(payload) {
  return {
    type: UPDATE_ENTERPRISE_BEGIN,
    payload,
  };
}

export function updateEnterpriseSuccess(payload) {
  return {
    type: UPDATE_ENTERPRISE_SUCCESS,
    payload,
  };
}

export function updateEnterpriseError(error) {
  return {
    type: UPDATE_ENTERPRISE_ERROR,
    error,
  };
}

export function configurationUnmount() {
  return {
    type: CONFIGURATION_UNMOUNT
  };
}
