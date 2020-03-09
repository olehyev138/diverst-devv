/*
 *
 * Policy actions
 *
 */

import {
  GET_POLICY_BEGIN,
  GET_POLICY_SUCCESS,
  GET_POLICY_ERROR,
  GET_POLICIES_BEGIN,
  GET_POLICIES_SUCCESS,
  GET_POLICIES_ERROR,
  CREATE_POLICY_BEGIN,
  CREATE_POLICY_SUCCESS,
  CREATE_POLICY_ERROR,
  UPDATE_POLICY_BEGIN,
  UPDATE_POLICY_SUCCESS,
  UPDATE_POLICY_ERROR,
  DELETE_POLICY_BEGIN,
  DELETE_POLICY_SUCCESS,
  DELETE_POLICY_ERROR,
  POLICIES_UNMOUNT,
} from './constants';

export function getPolicyBegin(payload) {
  return {
    type: GET_POLICY_BEGIN,
    payload,
  };
}

export function getPolicySuccess(payload) {
  return {
    type: GET_POLICY_SUCCESS,
    payload,
  };
}

export function getPolicyError(error) {
  return {
    type: GET_POLICY_ERROR,
    error,
  };
}

export function getPoliciesBegin(payload) {
  return {
    type: GET_POLICIES_BEGIN,
    payload,
  };
}

export function getPoliciesSuccess(payload) {
  return {
    type: GET_POLICIES_SUCCESS,
    payload,
  };
}

export function getPoliciesError(error) {
  return {
    type: GET_POLICIES_ERROR,
    error,
  };
}

export function createPolicyBegin(payload) {
  return {
    type: CREATE_POLICY_BEGIN,
    payload,
  };
}

export function createPolicySuccess(payload) {
  return {
    type: CREATE_POLICY_SUCCESS,
    payload,
  };
}

export function createPolicyError(error) {
  return {
    type: CREATE_POLICY_ERROR,
    error,
  };
}

export function updatePolicyBegin(payload) {
  return {
    type: UPDATE_POLICY_BEGIN,
    payload,
  };
}

export function updatePolicySuccess(payload) {
  return {
    type: UPDATE_POLICY_SUCCESS,
    payload,
  };
}

export function updatePolicyError(error) {
  return {
    type: UPDATE_POLICY_ERROR,
    error,
  };
}

export function deletePolicyBegin(payload) {
  return {
    type: DELETE_POLICY_BEGIN,
    payload,
  };
}

export function deletePolicySuccess(payload) {
  return {
    type: DELETE_POLICY_SUCCESS,
    payload,
  };
}

export function deletePolicyError(error) {
  return {
    type: DELETE_POLICY_ERROR,
    error,
  };
}

export function policiesUnmount(payload) {
  return {
    type: POLICIES_UNMOUNT,
    payload,
  };
}
