/*
 *
 * Budget actions
 *
 */

import {
  GET_BUDGET_BEGIN,
  GET_BUDGET_SUCCESS,
  GET_BUDGET_ERROR,
  GET_BUDGETS_BEGIN,
  GET_BUDGETS_SUCCESS,
  GET_BUDGETS_ERROR,
  CREATE_BUDGET_REQUEST_BEGIN,
  CREATE_BUDGET_REQUEST_SUCCESS,
  CREATE_BUDGET_REQUEST_ERROR,
  APPROVE_BUDGET_BEGIN,
  APPROVE_BUDGET_SUCCESS,
  APPROVE_BUDGET_ERROR,
  DECLINE_BUDGET_BEGIN,
  DECLINE_BUDGET_SUCCESS,
  DECLINE_BUDGET_ERROR,
  DELETE_BUDGET_BEGIN,
  DELETE_BUDGET_SUCCESS,
  DELETE_BUDGET_ERROR,
  BUDGETS_UNMOUNT,
} from './constants';

export function getBudgetBegin(payload) {
  return {
    type: GET_BUDGET_BEGIN,
    payload,
  };
}

export function getBudgetSuccess(payload) {
  return {
    type: GET_BUDGET_SUCCESS,
    payload,
  };
}

export function getBudgetError(error) {
  return {
    type: GET_BUDGET_ERROR,
    error,
  };
}

export function getBudgetsBegin(payload) {
  return {
    type: GET_BUDGETS_BEGIN,
    payload,
  };
}

export function getBudgetsSuccess(payload) {
  return {
    type: GET_BUDGETS_SUCCESS,
    payload,
  };
}

export function getBudgetsError(error) {
  return {
    type: GET_BUDGETS_ERROR,
    error,
  };
}

export function createBudgetRequestBegin(payload) {
  return {
    type: CREATE_BUDGET_REQUEST_BEGIN,
    payload,
  };
}

export function createBudgetRequestSuccess(payload) {
  return {
    type: CREATE_BUDGET_REQUEST_SUCCESS,
    payload,
  };
}

export function createBudgetRequestError(error) {
  return {
    type: CREATE_BUDGET_REQUEST_ERROR,
    error,
  };
}

export function approveBudgetBegin(payload) {
  return {
    type: APPROVE_BUDGET_BEGIN,
    payload,
  };
}

export function approveBudgetSuccess(payload) {
  return {
    type: APPROVE_BUDGET_SUCCESS,
    payload,
  };
}

export function approveBudgetError(error) {
  return {
    type: APPROVE_BUDGET_ERROR,
    error,
  };
}

export function declineBudgetBegin(payload) {
  return {
    type: DECLINE_BUDGET_BEGIN,
    payload,
  };
}

export function declineBudgetSuccess(payload) {
  return {
    type: DECLINE_BUDGET_SUCCESS,
    payload,
  };
}

export function declineBudgetError(error) {
  return {
    type: DECLINE_BUDGET_ERROR,
    error,
  };
}

export function deleteBudgetBegin(payload) {
  return {
    type: DELETE_BUDGET_BEGIN,
    payload,
  };
}

export function deleteBudgetSuccess(payload) {
  return {
    type: DELETE_BUDGET_SUCCESS,
    payload,
  };
}

export function deleteBudgetError(error) {
  return {
    type: DELETE_BUDGET_ERROR,
    error,
  };
}

export function budgetsUnmount(payload) {
  return {
    type: BUDGETS_UNMOUNT,
    payload,
  };
}
