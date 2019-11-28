import {
  GET_SSOSETTING_BEGIN, GET_SSOSETTING_SUCCESS, GET_SSOSETTING_ERROR,
  UPDATE_SSOSETTING_BEGIN, UPDATE_SSOSETTING_SUCCESS, UPDATE_SSOSETTING_ERROR,
  SSOSETTING_UNMOUNT
} from 'containers/GlobalSettings/constants';

/* Getting SSOSetting */

export function getSSOSettingBegin(payload) {
  return {
    type: GET_SSOSETTING_BEGIN,
    payload,
  };
}

export function getSSOSettingSuccess(payload) {
  return {
    type: GET_SSOSETTING_SUCCESS,
    payload,
  };
}

export function getSSOSettingError(error) {
  return {
    type: GET_SSOSETTING_ERROR,
    error,
  };
}

/* SSOSETTING updating */

export function updateSSOSettingBegin(payload) {
  return {
    type: UPDATE_SSOSETTING_BEGIN,
    payload,
  };
}

export function updateSSOSettingSuccess(payload) {
  return {
    type: UPDATE_SSOSETTING_SUCCESS,
    payload,
  };
}

export function updateSSOSettingError(error) {
  return {
    type: UPDATE_SSOSETTING_ERROR,
    error,
  };
}

export function SSOSettingUnmount() {
  return {
    type: SSOSETTING_UNMOUNT
  };
}
