/*
 *
 * SignUp actions
 *
 */

import {
  GET_USER_BY_TOKEN_BEGIN,
  GET_USER_BY_TOKEN_SUCCESS,
  GET_USER_BY_TOKEN_ERROR,
  GET_ONBOARDING_GROUPS_BEGIN,
  GET_ONBOARDING_GROUPS_SUCCESS,
  GET_ONBOARDING_GROUPS_ERROR,
  SUBMIT_PASSWORD_BEGIN,
  SUBMIT_PASSWORD_SUCCESS,
  SUBMIT_PASSWORD_ERROR,
  SIGN_UP_UNMOUNT,
} from './constants';

export function getUserByTokenBegin(payload) {
  return {
    type: GET_USER_BY_TOKEN_BEGIN,
    payload
  };
}

export function getUserByTokenSuccess(payload) {
  return {
    type: GET_USER_BY_TOKEN_SUCCESS,
    payload
  };
}

export function getUserByTokenError(error) {
  return {
    type: GET_USER_BY_TOKEN_ERROR,
    error
  };
}

export function getOnboardingGroupsBegin(payload) {
  return {
    type: GET_ONBOARDING_GROUPS_BEGIN,
    payload
  };
}

export function getOnboardingGroupsSuccess(payload) {
  return {
    type: GET_ONBOARDING_GROUPS_SUCCESS,
    payload
  };
}

export function getOnboardingGroupsError(error) {
  return {
    type: GET_ONBOARDING_GROUPS_ERROR,
    error
  };
}

export function submitPasswordBegin(payload) {
  return {
    type: SUBMIT_PASSWORD_BEGIN,
    payload
  };
}

export function submitPasswordSuccess(payload) {
  return {
    type: SUBMIT_PASSWORD_SUCCESS,
    payload
  };
}

export function submitPasswordError(error) {
  return {
    type: SUBMIT_PASSWORD_ERROR,
    error
  };
}

export function signUpUnmount(errors) {
  return {
    type: SIGN_UP_UNMOUNT,
    errors
  };
}
