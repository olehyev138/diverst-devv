/*
 *
 * Sso Settings actions
 *
 */

import {
  UPDATE_SSO_SETTINGS_BEGIN,
  UPDATE_SSO_SETTINGS_SUCCESS,
  UPDATE_SSO_SETTINGS_ERROR,
} from './constants';

export function updateSsoSettingsBegin(payload) {
  return {
    type: UPDATE_SSO_SETTINGS_BEGIN,
    payload,
  };
}

export function updateSsoSettingsSuccess(payload) {
  return {
    type: UPDATE_SSO_SETTINGS_SUCCESS,
    payload,
  };
}

export function updateSsoSettingsError(error) {
  return {
    type: UPDATE_SSO_SETTINGS_ERROR,
    error,
  };
}
